// current_lesson_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adibasa_app/models/lesson_model.dart';
import 'package:adibasa_app/providers/lessons_provider.dart';

class CurrentLessonNotifier extends StateNotifier<Lesson?> {
  CurrentLessonNotifier(this.ref) : super(null);
  final Ref ref;

  void setLesson(Lesson newLesson) {
    state = newLesson;
  }

  void reset() {
    state = null;
  }

  Lesson? getNextLesson() {
    if (state == null) return null;

    final allLessons = ref.read(lessonsProvider).value ?? [];

    // Pastikan lessons diurutkan berdasarkan order
    allLessons.sort((a, b) => a.order.compareTo(b.order));

    // Cari index berdasarkan order bukan ID
    final currentIndex = allLessons.indexWhere((l) => l.order == state!.order);

    if (currentIndex == -1 || currentIndex + 1 >= allLessons.length) return null;

    return allLessons[currentIndex + 1];
  }
}

final currentLessonProvider = StateNotifierProvider<CurrentLessonNotifier, Lesson?>(
      (ref) => CurrentLessonNotifier(ref),
);