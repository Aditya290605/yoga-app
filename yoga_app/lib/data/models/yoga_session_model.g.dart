// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yoga_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YogaSessionModel _$YogaSessionModelFromJson(Map<String, dynamic> json) =>
    YogaSessionModel(
      metadata: SessionMetadataModel.fromJson(
        json['metadata'] as Map<String, dynamic>,
      ),
      assets: SessionAssetsModel.fromJson(
        json['assets'] as Map<String, dynamic>,
      ),
      sequence: (json['sequence'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$YogaSessionModelToJson(YogaSessionModel instance) =>
    <String, dynamic>{
      'metadata': instance.metadata,
      'assets': instance.assets,
      'sequence': instance.sequence,
    };

SessionMetadataModel _$SessionMetadataModelFromJson(
  Map<String, dynamic> json,
) => SessionMetadataModel(
  id: json['id'] as String,
  title: json['title'] as String,
  category: json['category'] as String,
  defaultLoopCount: (json['defaultLoopCount'] as num).toInt(),
  tempo: json['tempo'] as String,
);

Map<String, dynamic> _$SessionMetadataModelToJson(
  SessionMetadataModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'category': instance.category,
  'defaultLoopCount': instance.defaultLoopCount,
  'tempo': instance.tempo,
};

SessionAssetsModel _$SessionAssetsModelFromJson(Map<String, dynamic> json) =>
    SessionAssetsModel(
      images: Map<String, String>.from(json['images'] as Map),
      audio: Map<String, String>.from(json['audio'] as Map),
    );

Map<String, dynamic> _$SessionAssetsModelToJson(SessionAssetsModel instance) =>
    <String, dynamic>{'images': instance.images, 'audio': instance.audio};

ScriptItemModel _$ScriptItemModelFromJson(Map<String, dynamic> json) =>
    ScriptItemModel(
      text: json['text'] as String,
      startSec: (json['startSec'] as num).toInt(),
      endSec: (json['endSec'] as num).toInt(),
      imageRef: json['imageRef'] as String,
    );

Map<String, dynamic> _$ScriptItemModelToJson(ScriptItemModel instance) =>
    <String, dynamic>{
      'text': instance.text,
      'startSec': instance.startSec,
      'endSec': instance.endSec,
      'imageRef': instance.imageRef,
    };
