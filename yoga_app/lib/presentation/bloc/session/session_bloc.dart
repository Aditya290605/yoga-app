import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:yoga_app/domain/entities/session_state.dart';
import 'package:yoga_app/domain/entities/yoga_session.dart';
import 'package:yoga_app/domain/usecases/load_session.dart';
import 'package:yoga_app/presentation/services/audio_service.dart';

part 'session_event.dart';
part 'session_state_bloc.dart';

@injectable
class SessionBloc extends Bloc<SessionEvent, SessionBlocState> {
  final LoadSession loadSession;
  final AudioService audioService;
  Timer? _timer;
  SessionState _currentSessionState = const SessionState();

  SessionBloc(this.loadSession, this.audioService)
    : super(const SessionBlocState.initial()) {
    on<LoadSessionEvent>(_onLoadSession);
    on<StartSessionEvent>(_onStartSession);
    on<PauseSessionEvent>(_onPauseSession);
    on<ResumeSessionEvent>(_onResumeSession);
    on<StopSessionEvent>(_onStopSession);
    on<SessionTickEvent>(_onSessionTick);
    on<ToggleBackgroundMusicEvent>(_onToggleBackgroundMusic);
  }

  Future<void> _onLoadSession(
    LoadSessionEvent event,
    Emitter<SessionBlocState> emit,
  ) async {
    emit(const SessionBlocState.loading());

    final result = await loadSession(event.sessionId);

    result.fold((failure) => emit(SessionBlocState.error(failure.message)), (
      session,
    ) {
      _currentSessionState = _currentSessionState.copyWith(
        session: session,
        status: SessionStatus.idle,
        totalDuration: _calculateTotalDuration(session),
      );
      emit(SessionBlocState.loaded(_currentSessionState));
    });
  }

  Future<void> _onStartSession(
    StartSessionEvent event,
    Emitter<SessionBlocState> emit,
  ) async {
    if (_currentSessionState.session == null) return;

    _currentSessionState = _currentSessionState.copyWith(
      status: SessionStatus.playing,
      currentSequenceIndex: 0,
      currentScriptIndex: 0,
      currentDuration: Duration.zero,
    );

    await _startCurrentSequence();
    _startTimer();

    emit(SessionBlocState.playing(_currentSessionState));
  }

  Future<void> _onPauseSession(
    PauseSessionEvent event,
    Emitter<SessionBlocState> emit,
  ) async {
    _timer?.cancel();
    await audioService.pauseAll();

    _currentSessionState = _currentSessionState.copyWith(
      status: SessionStatus.paused,
    );
    emit(SessionBlocState.paused(_currentSessionState));
  }

  Future<void> _onResumeSession(
    ResumeSessionEvent event,
    Emitter<SessionBlocState> emit,
  ) async {
    await audioService.resumeAll();
    _startTimer();

    _currentSessionState = _currentSessionState.copyWith(
      status: SessionStatus.playing,
    );
    emit(SessionBlocState.playing(_currentSessionState));
  }

  Future<void> _onStopSession(
    StopSessionEvent event,
    Emitter<SessionBlocState> emit,
  ) async {
    _timer?.cancel();
    await audioService.stopAll();

    _currentSessionState = _currentSessionState.copyWith(
      status: SessionStatus.idle,
      currentSequenceIndex: 0,
      currentScriptIndex: 0,
      currentDuration: Duration.zero,
    );
    emit(SessionBlocState.stopped(_currentSessionState));
  }

  void _onSessionTick(SessionTickEvent event, Emitter<SessionBlocState> emit) {
    if (_currentSessionState.session == null ||
        _currentSessionState.status != SessionStatus.playing) {
      return;
    }

    final newDuration =
        _currentSessionState.currentDuration + const Duration(seconds: 1);
    _currentSessionState = _currentSessionState.copyWith(
      currentDuration: newDuration,
    );

    final currentSequence = _getCurrentSequence();
    final currentScript = _getCurrentScript();

    if (currentScript != null) {
      final scriptEndTime = Duration(seconds: currentScript.endSec);

      if (newDuration >= scriptEndTime) {
        _moveToNextScript();
      }

      _updateCurrentState();
    }

    emit(SessionBlocState.playing(_currentSessionState));

    // Check if session is complete
    if (_isSessionComplete()) {
      add(StopSessionEvent());
      _currentSessionState = _currentSessionState.copyWith(
        status: SessionStatus.completed,
      );
      emit(SessionBlocState.completed(_currentSessionState));
    }
  }

  void _onToggleBackgroundMusic(
    ToggleBackgroundMusicEvent event,
    Emitter<SessionBlocState> emit,
  ) {
    _currentSessionState = _currentSessionState.copyWith(
      isBackgroundMusicEnabled: !_currentSessionState.isBackgroundMusicEnabled,
    );
    emit(SessionBlocState.loaded(_currentSessionState));
  }

  Duration _calculateTotalDuration(YogaSession session) {
    int totalSeconds = 0;

    for (final sequence in session.sequence) {
      if (sequence is LoopItem) {
        totalSeconds += sequence.durationSec * sequence.iterations;
      } else {
        totalSeconds += sequence.durationSec;
      }
    }

    return Duration(seconds: totalSeconds);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(SessionTickEvent());
    });
  }

  Future<void> _startCurrentSequence() async {
    final currentSequence = _getCurrentSequence();
    if (currentSequence != null) {
      final audioPath = _getAudioPath(currentSequence.audioRef);
      if (audioPath != null) {
        await audioService.playAudio(audioPath);
      }
    }
  }

  SequenceItem? _getCurrentSequence() {
    if (_currentSessionState.session == null ||
        _currentSessionState.currentSequenceIndex >=
            _currentSessionState.session!.sequence.length) {
      return null;
    }
    return _currentSessionState.session!.sequence[_currentSessionState
        .currentSequenceIndex];
  }

  ScriptItem? _getCurrentScript() {
    final currentSequence = _getCurrentSequence();
    if (currentSequence == null ||
        _currentSessionState.currentScriptIndex >=
            currentSequence.script.length) {
      return null;
    }
    return currentSequence.script[_currentSessionState.currentScriptIndex];
  }

  String? _getAudioPath(String audioRef) {
    return _currentSessionState.session?.assets.audio[audioRef];
  }

  String? _getImagePath(String imageRef) {
    return _currentSessionState.session?.assets.images[imageRef];
  }

  void _moveToNextScript() {
    final currentSequence = _getCurrentSequence();
    if (currentSequence != null &&
        _currentSessionState.currentScriptIndex <
            currentSequence.script.length - 1) {
      _currentSessionState = _currentSessionState.copyWith(
        currentScriptIndex: _currentSessionState.currentScriptIndex + 1,
      );
    } else {
      _moveToNextSequence();
    }
  }

  void _moveToNextSequence() {
    if (_currentSessionState.session != null &&
        _currentSessionState.currentSequenceIndex <
            _currentSessionState.session!.sequence.length - 1) {
      _currentSessionState = _currentSessionState.copyWith(
        currentSequenceIndex: _currentSessionState.currentSequenceIndex + 1,
        currentScriptIndex: 0,
      );
      _startCurrentSequence();
    }
  }

  void _updateCurrentState() {
    final currentScript = _getCurrentScript();
    if (currentScript != null) {
      final imagePath = _getImagePath(currentScript.imageRef);
      _currentSessionState = _currentSessionState.copyWith(
        currentImagePath: imagePath,
        currentText: currentScript.text,
      );
    }
  }

  bool _isSessionComplete() {
    return _currentSessionState.currentSequenceIndex >=
        (_currentSessionState.session?.sequence.length ?? 0);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
