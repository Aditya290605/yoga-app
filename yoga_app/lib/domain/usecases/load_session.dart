import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:yoga_app/core/error/failures.dart';
import 'package:yoga_app/domain/entities/yoga_session.dart';
import 'package:yoga_app/domain/repositories/session_repository.dart';

@injectable
class LoadSession {
  final SessionRepository repository;

  LoadSession(this.repository);

  Future<Either<Failure, YogaSession>> call(String sessionId) async {
    return await repository.loadSession(sessionId);
  }
}
