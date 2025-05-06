import 'dart:async';
import 'package:adibasa_app/providers/user_data_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adibasa_app/models/lesson_model.dart';
import 'package:adibasa_app/providers/lessons_provider.dart';

// Model state untuk game
class LessonGameState {
  final Lesson? currentLesson;
  final Duration duration;
  final int stars;
  final bool isTimerRunning;

  LessonGameState({
    this.currentLesson,
    this.duration = Duration.zero,
    this.stars = 0,
    this.isTimerRunning = false,
  });

  LessonGameState copyWith({
    Lesson? currentLesson,
    Duration? duration,
    int? stars,
    bool? isTimerRunning,
  }) {
    return LessonGameState(
      currentLesson: currentLesson ?? this.currentLesson,
      duration: duration ?? this.duration,
      stars: stars ?? this.stars,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
    );
  }
}

class LessonGameNotifier extends StateNotifier<LessonGameState> {
  LessonGameNotifier(this.ref) : super(LessonGameState());

  final Ref ref;
  Timer? _timer;

  // Fungsi untuk set lesson saat ini
  void setLesson(Lesson lesson) {
    // Create a new state with the provided lesson
    state = LessonGameState(
      currentLesson: lesson,
      duration: Duration.zero,
      stars: 0,
      isTimerRunning: false,
    );
  }

  Lesson? get currentLesson => state.currentLesson;
  int? get stars => state.stars;

  // Reset semua state
  void reset() {
    stopTimer();
    state = LessonGameState();
  }

  // Fungsi menghitung bintang berdasarkan durasi
  void calculateStars() {
    stopTimer();
    final duration = state.duration;
    final stars =
        duration.inSeconds <= 60
            ? 3
            : duration.inSeconds <= 120
            ? 2
            : 1;
    state = state.copyWith(stars: stars);
  }

  // Mendapatkan pelajaran berikutnya
  Lesson? getNextLesson() {
    if (state.currentLesson == null) {
      //print('Cannot get next lesson: currentLesson is null');
      return null;
    }

    final allLessons = ref.read(lessonsProvider).value ?? [];
    if (allLessons.isEmpty) {
      // print('Cannot get next lesson: no lessons available');
      return null;
    }

    // Pastikan lessons diurutkan berdasarkan order
    allLessons.sort((a, b) => a.order.compareTo(b.order));

    // Cari index berdasarkan order bukan ID
    final currentIndex = allLessons.indexWhere(
      (l) => l.order == state.currentLesson!.order,
    );

    if (currentIndex == -1) {
      // print('Current lesson not found in lessons list');
      return null;
    }

    if (currentIndex + 1 >= allLessons.length) {
      // print('This is the last lesson');
      return null;
    }

    return allLessons[currentIndex + 1];
  }

  // Mulai timer
  void startTimer() {
    _timer?.cancel();
    state = state.copyWith(isTimerRunning: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(
        duration: state.duration + const Duration(seconds: 1),
      );
    });
  }

  // Hentikan timer
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(isTimerRunning: false);
  }

  // Reset timer
  void resetTimer() {
    stopTimer();
    state = state.copyWith(duration: Duration.zero);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final lessonGameProvider =
    StateNotifierProvider<LessonGameNotifier, LessonGameState>(
      (ref) => LessonGameNotifier(ref),
    );
