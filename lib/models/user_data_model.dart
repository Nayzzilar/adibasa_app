import 'package:flutter/foundation.dart';

@immutable
class UserData {
  final int currentStreak;
  final Map<int, int> lessonStars; // Key: lesson.order
  final Set<String> seenWords;

  const UserData({
    required this.currentStreak,
    required this.lessonStars,
    required this.seenWords,
  });

  UserData copyWith({
    int? currentStreak,
    Map<int, int>? lessonStars,
    Set<String>? seenWords,
  }) {
    return UserData(
      currentStreak: currentStreak ?? this.currentStreak,
      lessonStars: lessonStars ?? this.lessonStars,
      seenWords: seenWords ?? this.seenWords,
    );
  }

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    currentStreak: json['currentStreak'] ?? 0,
    lessonStars:
        (json['lessonStars'] as Map<String, dynamic>?)?.map(
          (k, v) => MapEntry(int.parse(k), v as int),
        ) ??
        {},
    seenWords:
        (json['seenWords'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toSet() ??
        {},
  );

  Map<String, dynamic> toJson() => {
    'currentStreak': currentStreak,
    'lessonStars': lessonStars.map((k, v) => MapEntry(k.toString(), v)),
    'seenWords': seenWords.toList(),
  };
}
