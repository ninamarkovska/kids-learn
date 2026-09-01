import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    try {
      // Обид за македонски, fallback на српски или хрватски
      final languages = await _tts.getLanguages as List?;
      if (languages != null) {
        if (languages.contains('mk-MK')) {
          await _tts.setLanguage('mk-MK');
        } else if (languages.contains('sr-RS')) {
          await _tts.setLanguage('sr-RS');
        } else if (languages.contains('hr-HR')) {
          await _tts.setLanguage('hr-HR');
        } else {
          await _tts.setLanguage('bs-BA');
        }
      }
      await _tts.setSpeechRate(0.4); // Побавно за деца
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.2); // Малку повисок глас за деца
      _initialized = true;
    } catch (e) {
      debugPrint('TTS init error: $e');
      _initialized = true;
    }
  }

  Future<void> speak(String text) async {
    try {
      await _init();
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      debugPrint('TTS speak error: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (e) {
      debugPrint('TTS stop error: $e');
    }
  }

  Future<void> speakLetter(String letter) async {
    await speak('Буквата $letter');
  }

  Future<void> speakAnimal(String animalName) async {
    await speak(animalName);
  }

  Future<void> speakColor(String colorName) async {
    await speak('Бојата $colorName');
  }

  Future<void> speakShape(String shapeName) async {
    await speak('Формата $shapeName');
  }

  void dispose() {
    _tts.stop();
  }
}
