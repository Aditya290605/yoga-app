import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:yoga_app/data/models/yoga_session_model.dart';
import 'package:yoga_app/domain/entities/yoga_session.dart';

abstract class LocalSessionDatasource {
  Future<YogaSession> loadSession(String sessionId);
  Future<List<YogaSession>> getAllSessions();
}

@LazySingleton(as: LocalSessionDatasource)
class LocalSessionDatasourceImpl implements LocalSessionDatasource {
  @override
  Future<YogaSession> loadSession(String sessionId) async {
    try {
      // Load the JSON file from assets
      final String jsonString = await rootBundle.loadString(
        'assets/data/cat_cow_session.json',
      );
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      return YogaSessionModel.fromJson(jsonMap).toDomain();
    } catch (e) {
      throw Exception('Failed to load session: $e');
    }
  }

  @override
  Future<List<YogaSession>> getAllSessions() async {
    try {
      // For now, we only have one session
      final session = await loadSession('asana_cat_cow_v1');
      return [session];
    } catch (e) {
      throw Exception('Failed to load sessions: $e');
    }
  }
}
