import 'package:flutter_riverpod/flutter_riverpod.dart';

class DurationNotifier extends StateNotifier<Duration> {
  DurationNotifier() : super(Duration.zero);

  void setDuration(Duration newDuration) {
    state = newDuration;
  }

  void resetDuration() {
    state = Duration.zero;
  }
}

final durationProvider = StateNotifierProvider<DurationNotifier, Duration>(
  (ref) => DurationNotifier(),
);
