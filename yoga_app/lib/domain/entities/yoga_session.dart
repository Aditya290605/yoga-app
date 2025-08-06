import 'package:equatable/equatable.dart';

class YogaSession extends Equatable {
  final SessionMetadata metadata;
  final SessionAssets assets;
  final List<SequenceItem> sequence;

  const YogaSession({
    required this.metadata,
    required this.assets,
    required this.sequence,
  });

  @override
  List<Object?> get props => [metadata, assets, sequence];
}

class SessionMetadata extends Equatable {
  final String id;
  final String title;
  final String category;
  final int defaultLoopCount;
  final String tempo;

  const SessionMetadata({
    required this.id,
    required this.title,
    required this.category,
    required this.defaultLoopCount,
    required this.tempo,
  });

  @override
  List<Object?> get props => [id, title, category, defaultLoopCount, tempo];
}

class SessionAssets extends Equatable {
  final Map<String, String> images;
  final Map<String, String> audio;

  const SessionAssets({
    required this.images,
    required this.audio,
  });

  @override
  List<Object?> get props => [images, audio];
}

abstract class SequenceItem extends Equatable {
  final String type;
  final String name;
  final String audioRef;
  final int durationSec;
  final List<ScriptItem> script;

  const SequenceItem({
    required this.type,
    required this.name,
    required this.audioRef,
    required this.durationSec,
    required this.script,
  });
}

class SegmentItem extends SequenceItem {
  const SegmentItem({
    required super.name,
    required super.audioRef,
    required super.durationSec,
    required super.script,
  }) : super(type: 'segment');

  @override
  List<Object?> get props => [type, name, audioRef, durationSec, script];
}

class LoopItem extends SequenceItem {
  final int iterations;
  final bool loopable;

  const LoopItem({
    required super.name,
    required super.audioRef,
    required super.durationSec,
    required super.script,
    required this.iterations,
    required this.loopable,
  }) : super(type: 'loop');

  @override
  List<Object?> get props => [type, name, audioRef, durationSec, script, iterations, loopable];
}

class ScriptItem extends Equatable {
  final String text;
  final int startSec;
  final int endSec;
  final String imageRef;

  const ScriptItem({
    required this.text,
    required this.startSec,
    required this.endSec,
    required this.imageRef,
  });

  @override
  List<Object?> get props => [text, startSec, endSec, imageRef];
}