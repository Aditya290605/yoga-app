import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:yoga_app/core/error/failures.dart';
import 'package:yoga_app/data/datasources/local_session_datasource.dart';
import 'package:yoga_app/domain/entities/yoga_session.dart';
import 'package:yoga_app/domain/repositories/session_repository.dart';

@LazySingleton(as: SessionRepository)
class SessionRepositoryImpl implements SessionRepository {
  final LocalSessionDatasource localDatasource;

  SessionRepositoryImpl(this.localDatasource);

  @override
  Future<Either<Failure, YogaSession>> loadSession(String sessionId) async {
    try {
      final session = await localDatasource.loadSession(sessionId);
      return Right(session);
    } catch (e) {
      return Left(CacheFailure('Failed to load session: $e'));
    }
  }

  @override
  Future<Either<Failure, List<YogaSession>>> getAllSessions() async {
    try {
      final sessions = await localDatasource.getAllSessions();
      return Right(sessions);
    } catch (e) {
      return Left(CacheFailure('Failed to load sessions: $e'));
    }
  }
}
