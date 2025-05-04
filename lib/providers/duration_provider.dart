import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DurationNotifier extends StateNotifier<Duration> {
  Timer? _timer;

  DurationNotifier() : super(Duration.zero);

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state += const Duration(seconds: 1);
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void reset() {
    stop();
    state = Duration.zero;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final durationProvider = StateNotifierProvider<DurationNotifier, Duration>(
      (ref) => DurationNotifier(),
);
