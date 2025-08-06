import 'package:equatable/equatable.dart';

import 'package:yoga_app/domain/entities/yoga_session.dart';

enum SessionStatus { idle, playing, paused, completed }

class SessionState extends Equatable {
  final YogaSession? session;
  final SessionStatus status;
  final int currentSequenceIndex;
  final int currentScriptIndex;
  final Duration currentDuration;
  final Duration totalDuration;
  final String? currentImagePath;
  final String? currentText;
  final bool isBackgroundMusicEnabled;

  const SessionState({
    this.session,
    this.status = SessionStatus.idle,
    this.currentSequenceIndex = 0,
    this.currentScriptIndex = 0,
    this.currentDuration = Duration.zero,
    this.totalDuration = Duration.zero,
    this.currentImagePath,
    this.currentText,
    this.isBackgroundMusicEnabled = false,
  });

  SessionState copyWith({
    YogaSession? session,
    SessionStatus? status,
    int? currentSequenceIndex,
    int? currentScriptIndex,
    Duration? currentDuration,
    Duration? totalDuration,
    String? currentImagePath,
    String? currentText,
    bool? isBackgroundMusicEnabled,
  }) {
    return SessionState(
      session: session ?? this.session,
      status: status ?? this.status,
      currentSequenceIndex: currentSequenceIndex ?? this.currentSequenceIndex,
      currentScriptIndex: currentScriptIndex ?? this.currentScriptIndex,
      currentDuration: currentDuration ?? this.currentDuration,
      totalDuration: totalDuration ?? this.totalDuration,
      currentImagePath: currentImagePath ?? this.currentImagePath,
      currentText: currentText ?? this.currentText,
      isBackgroundMusicEnabled:
          isBackgroundMusicEnabled ?? this.isBackgroundMusicEnabled,
    );
  }

  @override
  List<Object?> get props => [
    session,
    status,
    currentSequenceIndex,
    currentScriptIndex,
    currentDuration,
    totalDuration,
    currentImagePath,
    currentText,
    isBackgroundMusicEnabled,
  ];
}
