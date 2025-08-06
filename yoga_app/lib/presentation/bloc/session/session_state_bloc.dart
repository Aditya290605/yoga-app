part of 'session_bloc.dart';

abstract class SessionBlocState extends Equatable {
  const SessionBlocState();

  const factory SessionBlocState.initial() = Initial;
  const factory SessionBlocState.loading() = Loading;
  const factory SessionBlocState.loaded(SessionState sessionState) = Loaded;
  const factory SessionBlocState.playing(SessionState sessionState) = Playing;
  const factory SessionBlocState.paused(SessionState sessionState) = Paused;
  const factory SessionBlocState.stopped(SessionState sessionState) = Stopped;
  const factory SessionBlocState.completed(SessionState sessionState) =
      Completed;
  const factory SessionBlocState.error(String message) = Error;

  @override
  List<Object?> get props => [];
}

class Initial extends SessionBlocState {
  const Initial();
}

class Loading extends SessionBlocState {
  const Loading();
}

class Loaded extends SessionBlocState {
  final SessionState sessionState;

  const Loaded(this.sessionState);

  @override
  List<Object?> get props => [sessionState];
}

class Playing extends SessionBlocState {
  final SessionState sessionState;

  const Playing(this.sessionState);

  @override
  List<Object?> get props => [sessionState];
}

class Paused extends SessionBlocState {
  final SessionState sessionState;

  const Paused(this.sessionState);

  @override
  List<Object?> get props => [sessionState];
}

class Stopped extends SessionBlocState {
  final SessionState sessionState;

  const Stopped(this.sessionState);

  @override
  List<Object?> get props => [sessionState];
}

class Completed extends SessionBlocState {
  final SessionState sessionState;

  const Completed(this.sessionState);

  @override
  List<Object?> get props => [sessionState];
}

class Error extends SessionBlocState {
  final String message;

  const Error(this.message);

  @override
  List<Object?> get props => [message];
}
