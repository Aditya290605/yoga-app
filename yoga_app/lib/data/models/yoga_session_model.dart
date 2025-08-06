import 'package:json_annotation/json_annotation.dart';
import 'package:yoga_app/domain/entities/yoga_session.dart';

part 'yoga_session_model.g.dart';

@JsonSerializable()
class YogaSessionModel {
  final SessionMetadataModel metadata;
  final SessionAssetsModel assets;
  final List<Map<String, dynamic>> sequence;

  YogaSessionModel({
    required this.metadata,
    required this.assets,
    required this.sequence,
  });

  factory YogaSessionModel.fromJson(Map<String, dynamic> json) =>
      _$YogaSessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$YogaSessionModelToJson(this);

  YogaSession toDomain() {
    return YogaSession(
      metadata: metadata.toDomain(),
      assets: assets.toDomain(),
      sequence: sequence.map((item) => _parseSequenceItem(item)).toList(),
    );
  }

  SequenceItem _parseSequenceItem(Map<String, dynamic> json) {
    final type = json['type'] as String;
    final script = (json['script'] as List)
        .map((item) => ScriptItemModel.fromJson(item).toDomain())
        .toList();

    if (type == 'loop') {
      final iterationsValue = json['iterations'];
      int iterations = 1;

      if (iterationsValue is String && iterationsValue == '{{loopCount}}') {
        iterations = metadata.defaultLoopCount;
      } else if (iterationsValue is int) {
        iterations = iterationsValue;
      }

      return LoopItem(
        name: json['name'],
        audioRef: json['audioRef'],
        durationSec: json['durationSec'],
        script: script,
        iterations: iterations,
        loopable: json['loopable'] ?? false,
      );
    } else {
      return SegmentItem(
        name: json['name'],
        audioRef: json['audioRef'],
        durationSec: json['durationSec'],
        script: script,
      );
    }
  }
}

@JsonSerializable()
class SessionMetadataModel {
  final String id;
  final String title;
  final String category;
  final int defaultLoopCount;
  final String tempo;

  SessionMetadataModel({
    required this.id,
    required this.title,
    required this.category,
    required this.defaultLoopCount,
    required this.tempo,
  });

  factory SessionMetadataModel.fromJson(Map<String, dynamic> json) =>
      _$SessionMetadataModelFromJson(json);

  Map<String, dynamic> toJson() => _$SessionMetadataModelToJson(this);

  SessionMetadata toDomain() {
    return SessionMetadata(
      id: id,
      title: title,
      category: category,
      defaultLoopCount: defaultLoopCount,
      tempo: tempo,
    );
  }
}

@JsonSerializable()
class SessionAssetsModel {
  final Map<String, String> images;
  final Map<String, String> audio;

  SessionAssetsModel({required this.images, required this.audio});

  factory SessionAssetsModel.fromJson(Map<String, dynamic> json) =>
      _$SessionAssetsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SessionAssetsModelToJson(this);

  SessionAssets toDomain() {
    return SessionAssets(images: images, audio: audio);
  }
}

@JsonSerializable()
class ScriptItemModel {
  final String text;
  final int startSec;
  final int endSec;
  final String imageRef;

  ScriptItemModel({
    required this.text,
    required this.startSec,
    required this.endSec,
    required this.imageRef,
  });

  factory ScriptItemModel.fromJson(Map<String, dynamic> json) =>
      _$ScriptItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScriptItemModelToJson(this);

  ScriptItem toDomain() {
    return ScriptItem(
      text: text,
      startSec: startSec,
      endSec: endSec,
      imageRef: imageRef,
    );
  }
}
