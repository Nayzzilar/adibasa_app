import 'package:flutter/material.dart';

class StarProvider extends ChangeNotifier {
  int _star = 0;

  int get star => _star;

  void calculateStar(Duration duration) {
    if (duration.inSeconds <= 60) {
      _star = 3;
    } else if (duration.inSeconds <= 120) {
      _star = 2;
    } else {
      _star = 1;
    }
    notifyListeners();
  }

  void resetStar() {
    _star = 0;
    notifyListeners();
  }
} 