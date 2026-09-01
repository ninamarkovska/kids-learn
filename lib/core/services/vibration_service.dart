import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/foundation.dart';

class VibrationService {
  static final VibrationService _instance = VibrationService._internal();
  factory VibrationService() => _instance;
  VibrationService._internal();

  Future<void> lightTap() async {
    try {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 50, amplitude: 50);
      } else {
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      debugPrint('Vibration error: $e');
    }
  }

  Future<void> success() async {
    try {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(pattern: [0, 80, 60, 80], intensities: [0, 128, 0, 200]);
      } else {
        HapticFeedback.mediumImpact();
      }
    } catch (e) {
      debugPrint('Vibration success error: $e');
    }
  }

  Future<void> error() async {
    try {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(pattern: [0, 200, 100, 200], intensities: [0, 200, 0, 200]);
      } else {
        HapticFeedback.heavyImpact();
      }
    } catch (e) {
      debugPrint('Vibration error error: $e');
    }
  }
}
