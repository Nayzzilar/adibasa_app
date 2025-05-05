import 'dart:convert';

import 'package:adibasa_app/models/user_data_model.dart';
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
      state = state.copyWith(seenWords: {...state.seenWords, word});
      _saveToPrefs();
    }
  }

  void completeLesson(int lessonOrder, int stars) {
    state = state.copyWith(
      lessonStars: {...state.lessonStars, lessonOrder: stars},
    );
    _saveToPrefs();
  }
}

final userDataProvider = StateNotifierProvider<UserDataNotifier, UserData>(
  (ref) => UserDataNotifier(),
);
