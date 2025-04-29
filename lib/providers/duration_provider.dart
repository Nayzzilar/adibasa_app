import 'package:flutter/material.dart';

class DurationProvider extends ChangeNotifier {
  Duration _duration = Duration.zero;

  Duration get duration => _duration;

  void setDuration(Duration newDuration) {
    _duration = newDuration;
    notifyListeners();
  }

  void resetDuration() {
    _duration = Duration.zero;
    notifyListeners();
  }
}