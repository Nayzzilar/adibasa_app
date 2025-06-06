import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adibasa_app/models/lesson_model.dart';
import 'package:adibasa_app/providers/lessons_provider.dart';
import 'package:adibasa_app/providers/user_data_provider.dart';

class LessonGameState {
  final Lesson? currentLesson;
  final Duration duration;
  final int stars;
  final bool isTimerRunning;
  final int percentage;
  final int challengesCorrect;
  final int challengesWrong;

  LessonGameState({
    this.currentLesson,
    this.duration = Duration.zero,
    this.stars = 0,
    this.isTimerRunning = false,
    this.percentage = 20,
    this.challengesCorrect = 0,
    this.challengesWrong = 0,
  });

  LessonGameState copyWith({
    Lesson? currentLesson,
    Duration? duration,
    int? stars,
    bool? isTimerRunning,
    int? percentage,
    int? challengesCorrect,
    int? challengesWrong,
  }) {
    return LessonGameState(
      currentLesson: currentLesson ?? this.currentLesson,
      duration: duration ?? this.duration,
      stars: stars ?? this.stars,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
      percentage: percentage ?? this.percentage,
      challengesCorrect: challengesCorrect ?? this.challengesCorrect,
      challengesWrong: challengesWrong ?? this.challengesWrong,
    );
  }

  // Helper getters for challenge statistics
  int get totalChallenges => challengesCorrect + challengesWrong;
  double get accuracyPercentage =>
      totalChallenges == 0 ? 0.0 : (challengesCorrect / totalChallenges) * 100;
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
      challengesCorrect: 0,
      challengesWrong: 0,
    );
  }

  Lesson? get currentLesson => state.currentLesson;
  int? get stars => state.stars;
  int get challengesCorrect => state.challengesCorrect;
  int get challengesWrong => state.challengesWrong;
  int get totalChallenges => state.totalChallenges;
  double get accuracyPercentage => state.accuracyPercentage;

  // Challenge tracking methods
  void incrementCorrectChallenge() {
    state = state.copyWith(challengesCorrect: state.challengesCorrect + 1);
  }

  void incrementWrongChallenge() {
    state = state.copyWith(challengesWrong: state.challengesWrong + 1);
  }

  // Method to record challenge result
  void recordChallengeResult(bool isCorrect) {
    if (isCorrect) {
      incrementCorrectChallenge();
    } else {
      incrementWrongChallenge();
    }
  }

  // Reset challenge counters
  void resetChallenges() {
    state = state.copyWith(challengesCorrect: 0, challengesWrong: 0);
  }

  // Reset semua state
  void reset() {
    stopTimer();
    state = LessonGameState();
  }

  // Fungsi menghitung bintang berdasarkan durasi dan akurasi
  void calculateStars() {
    stopTimer();
    final duration = state.duration;
    final accuracy = state.accuracyPercentage;

    // Calculate stars based on duration and accuracy
    int stars = 1;

    if (duration.inSeconds <= 60 && accuracy >= 90) {
      stars = 3;
    } else if (duration.inSeconds <= 120 && accuracy >= 80) {
      stars = 3;
    } else if (duration.inSeconds <= 180 && accuracy >= 70) {
      stars = 2;
    } else if (accuracy >= 60) {
      stars = 2;
    }

    state = state.copyWith(stars: stars);
  }

  // Alternative method for original star calculation (duration only)
  void calculateStarsByDuration() {
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

  // Menyimpan skor terbaik ke user data
  void saveCompletionWithBestScore() {
    if (state.currentLesson == null) return;

    final userDataNotifier = ref.read(userDataProvider.notifier);
    final currentLessonOrder = state.currentLesson!.order;
    final currentStars = state.stars;

    // Get previous completion data
    final userData = ref.read(userDataProvider);
    final previousStars = userData.lessonStars[currentLessonOrder] ?? 0;

    // Only update if current stars are higher than previous stars
    if (currentStars > previousStars) {
      userDataNotifier.completeLesson(currentLessonOrder, currentStars);
    }
  }

  // Mendapatkan pelajaran berikutnya
  Lesson? getNextLesson() {
    if (state.currentLesson == null) {
      return null;
    }

    final allLessons = ref.read(lessonsProvider).value ?? [];
    if (allLessons.isEmpty) {
      return null;
    }

    // Pastikan lessons diurutkan berdasarkan order
    allLessons.sort((a, b) => a.order.compareTo(b.order));

    // Cari index berdasarkan order bukan ID
    final currentIndex = allLessons.indexWhere(
      (l) => l.order == state.currentLesson!.order,
    );

    if (currentIndex == -1) {
      return null;
    }

    if (currentIndex + 1 >= allLessons.length) {
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
