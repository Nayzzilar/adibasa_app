import 'package:flutter_riverpod/flutter_riverpod.dart';

class StreakNotifier extends StateNotifier<int> {
  StreakNotifier() : super(0);

  void increment() => state++;
  void reset() => state = 0;
  void setValue(int value) => state = value;
}

final streakProvider = StateNotifierProvider<StreakNotifier, int>(
  (ref) => StreakNotifier(),
);
