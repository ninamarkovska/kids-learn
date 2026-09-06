import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  Future<void> playAsset(String assetPath) async {
    try {
      await stop();

      debugPrint("PLAYING >>> $assetPath"); // <-- додај ја оваа линија

      _isPlaying = true;
      await _player.play(AssetSource(assetPath));
    } catch (e) {
      debugPrint("ERROR >>> $e");
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
      _isPlaying = false;
    } catch (e) {
      debugPrint('AudioService stop error: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume.clamp(0.0, 1.0));
  }

  void dispose() {
    _player.dispose();
  }
}
