import 'package:flutter_riverpod/flutter_riverpod.dart';

class StarNotifier extends StateNotifier<int> {
  StarNotifier() : super(0);

  void calculateStar(Duration duration) {
    state = duration.inSeconds <= 60 ? 3 :
           duration.inSeconds <= 120 ? 2 : 1;
  }

  void resetStar() {
    state = 0;
  }
}

final starProvider = StateNotifierProvider<StarNotifier, int>(
  (ref) => StarNotifier(),
);
