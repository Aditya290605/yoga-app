part of 'session_bloc.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

class LoadSessionEvent extends SessionEvent {
  final String sessionId;

  const LoadSessionEvent(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class StartSessionEvent extends SessionEvent {
  const StartSessionEvent();
}

class PauseSessionEvent extends SessionEvent {
  const PauseSessionEvent();
}

class ResumeSessionEvent extends SessionEvent {
  const ResumeSessionEvent();
}

class StopSessionEvent extends SessionEvent {
  const StopSessionEvent();
}

class SessionTickEvent extends SessionEvent {
  const SessionTickEvent();
}

class ToggleBackgroundMusicEvent extends SessionEvent {
  const ToggleBackgroundMusicEvent();
}