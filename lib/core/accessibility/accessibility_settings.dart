import 'package:flutter/material.dart';

import 'accessible_palette.dart';

enum ColorVisionMode {
  standard,
  highContrast,
  protanopia,
  deuteranopia,
  tritanopia,
}

extension ColorVisionModeLabel on ColorVisionMode {
  String get label => switch (this) {
    ColorVisionMode.standard => 'Стандарден',
    ColorVisionMode.highContrast => 'Висок контраст',
    ColorVisionMode.protanopia => 'Протанопија',
    ColorVisionMode.deuteranopia => 'Деутеранопија',
    ColorVisionMode.tritanopia => 'Тританопија',
  };
}

class AccessibilitySettings extends ChangeNotifier {
  ColorVisionMode _colorVisionMode = ColorVisionMode.standard;

  ColorVisionMode get colorVisionMode => _colorVisionMode;

  AccessiblePalette get palette => AccessiblePalettes.forMode(_colorVisionMode);

  void setColorVisionMode(ColorVisionMode mode) {
    if (_colorVisionMode == mode) return;
    _colorVisionMode = mode;
    notifyListeners();
  }
}

class AccessibilityScope extends InheritedNotifier<AccessibilitySettings> {
  const AccessibilityScope({
    required AccessibilitySettings settings,
    required super.child,
    super.key,
  }) : super(notifier: settings);

  static AccessibilitySettings of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AccessibilityScope>();
    assert(
      scope != null,
      'AccessibilityScope was not found in the widget tree.',
    );
    return scope!.notifier!;
  }
}
