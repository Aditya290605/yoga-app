import 'package:audioplayers/audioplayers.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AudioService {
  final AudioPlayer _mainAudioPlayer = AudioPlayer();
  final AudioPlayer _backgroundMusicPlayer = AudioPlayer();
  
  bool _isBackgroundMusicEnabled = false;

  Future<void> playAudio(String audioPath) async {
    try {
      await _mainAudioPlayer.play(AssetSource('audio/$audioPath'));
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> playBackgroundMusic(String audioPath) async {
    if (!_isBackgroundMusicEnabled) return;
    
    try {
      await _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
      await _backgroundMusicPlayer.setVolume(0.3); // Lower volume for background
      await _backgroundMusicPlayer.play(AssetSource('audio/$audioPath'));
    } catch (e) {
      print('Error playing background music: $e');
    }
  }

  Future<void> pauseAll() async {
    await _mainAudioPlayer.pause();
    await _backgroundMusicPlayer.pause();
  }

  Future<void> resumeAll() async {
    await _mainAudioPlayer.resume();
    if (_isBackgroundMusicEnabled) {
      await _backgroundMusicPlayer.resume();
    }
  }

  Future<void> stopAll() async {
    await _mainAudioPlayer.stop();
    await _backgroundMusicPlayer.stop();
  }

  Future<void> setBackgroundMusicEnabled(bool enabled) async {
    _isBackgroundMusicEnabled = enabled;
    if (!enabled) {
      await _backgroundMusicPlayer.stop();
    }
  }

  void dispose() {
    _mainAudioPlayer.dispose();
    _backgroundMusicPlayer.dispose();
  }
}