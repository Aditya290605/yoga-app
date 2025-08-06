import 'package:dartz/dartz.dart';
import 'package:yoga_app/core/error/failures.dart';
import 'package:yoga_app/domain/entities/yoga_session.dart';

abstract class SessionRepository {
  Future<Either<Failure, YogaSession>> loadSession(String sessionId);
  Future<Either<Failure, List<YogaSession>>> getAllSessions();
}
