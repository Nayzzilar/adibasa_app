import 'dart:convert';

import 'package:adibasa_app/models/user_data_model.dart';
import 'package:adibasa_app/providers/lessons_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataNotifier extends StateNotifier<UserData> {
  UserDataNotifier()
    : super(const UserData(currentStreak: 0, lessonStars: {}, seenWords: {})) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    final json = prefs.getString('user_data');
    state =
        json != null
            ? UserData.fromJson(jsonDecode(json))
            : const UserData(currentStreak: 0, lessonStars: {}, seenWords: {});
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );
    await prefs.setString('user_data', jsonEncode(state.toJson()));
  }

  void incrementStreak() {
    state = state.copyWith(currentStreak: state.currentStreak + 1);
    _saveToPrefs();
  }

  void resetStreak() {
    state = state.copyWith(currentStreak: 0);
    _saveToPrefs();
  }

  void addSeenWord(String word) {
    if (!state.seenWords.contains(word)) {
      final newSeenWords = {...state.seenWords, word};
      state = state.copyWith(seenWords: newSeenWords);
      _saveToPrefs();
    }
  }

  void completeLesson(int lessonOrder, int stars) {
    state = state.copyWith(
      lessonStars: {...state.lessonStars, lessonOrder: stars},
    );
    _saveToPrefs();
  }

  int get nextLessonOrder {
    final completedLessons = state.lessonStars.keys.toList()..sort();
    for (int i = 1; i <= completedLessons.length + 1; i++) {
      if (!completedLessons.contains(i)) {
        return i; // Level berikutnya yang belum diselesaikan
      }
    }
    return 1; // Default ke level 1 jika tidak ada data
  }
}

final userDataProvider = StateNotifierProvider<UserDataNotifier, UserData>(
  (ref) => UserDataNotifier(),
);
