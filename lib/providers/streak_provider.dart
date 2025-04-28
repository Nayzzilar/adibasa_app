import 'package:flutter/material.dart';

class StreakProvider extends ChangeNotifier {
  int _streak = 0;

  int get streak => _streak;

  void incrementStreak() {
    _streak++;
    notifyListeners();
  }

  void resetStreak() {
    _streak = 0;
    notifyListeners();
  }

  void setStreak(int value) {
    _streak = value;
    notifyListeners();
  }
} 