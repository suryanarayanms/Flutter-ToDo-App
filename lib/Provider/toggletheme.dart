import 'package:flutter/material.dart';

class ChangeTheme extends ChangeNotifier {
  bool currenttheme = true;

  void toggletheme() {
    currenttheme = !currenttheme;
    notifyListeners();
  }
}
