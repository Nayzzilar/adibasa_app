import 'package:adibasa_app/models/level.dart';
import 'package:adibasa_app/providers/lessons_provider.dart';
import 'package:adibasa_app/providers/user_data_provider.dart';
import 'package:adibasa_app/widgets/level_selection/level_locked.dart';
import 'package:adibasa_app/widgets/level_selection/status_bar_level_selection.dart';
import 'package:flutter/material.dart';
import 'package:adibasa_app/widgets/level_selection/level_unlocked.dart';
import 'package:adibasa_app/models/lesson_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:adibasa_app/navigation/route_name.dart';
import 'package:adibasa_app/providers/lesson_game_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adibasa_app/widgets/level_selection/next_button_map.dart';
import 'package:adibasa_app/widgets/level_selection/previous_button_map.dart';

class LevelSelection extends ConsumerStatefulWidget {
  const LevelSelection({super.key});

  @override
  ConsumerState<LevelSelection> createState() => _LevelSelectionState();
}

class _LevelSelectionState extends ConsumerState<LevelSelection> {
  int currentMapIndex = 0; // 0: peta_bagian1, 1: peta_bagian2, 2: peta_bagian3
  static const List<int> levelsPerMap = [
    10,
    10,
    0,
  ]; // Total 20 level: 10, 10, 0

  final List<String> mapAssets = [
    'assets/images/peta_bagian_1.jpg',
    'assets/images/peta_bagian_2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final lessonsAsync = ref.watch(lessonsProvider);
    final gameState = ref.watch(lessonGameProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Baris 1: Status info (sama seperti app bar Kamus)
            const StatusBarLevelSelection(),
            // Konten utama
            Expanded(
              child: lessonsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
                data: (lessons) => _buildMapLevels(context, ref, lessons, gameState),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapLevels(
    BuildContext context,
    WidgetRef ref,
    List<Lesson> lessons,
    LessonGameState gameState,
  ) {
    final userData = ref.watch(userDataProvider);

    // Hitung range level untuk map saat ini
    int start = 0;
    for (int i = 0; i < currentMapIndex; i++) {
      start += levelsPerMap[i];
    }
    int end = start + levelsPerMap[currentMapIndex];

    // Buat 20 level: yang ada di lessons pakai data asli, sisanya dummy locked
    List<Level> allLevels = List.generate(20, (i) {
      if (i < lessons.length) {
        final lesson = lessons[i];
        final isFirstLevel = lesson.order == 1 || i == 0;
        final isLocked =
            !isFirstLevel &&
            !userData.lessonStars.containsKey(lesson.order - 1);
        final stars = userData.lessonStars[lesson.order] ?? 0;
        return Level(
          level: lesson.order,
          name: lesson.title,
          description: lesson.title,
          stars: stars,
          isLocked: isLocked,
        );
      } else {
        // Dummy locked
        return Level(
          level: i + 1,
          name: "Level ${i + 1}",
          description: "",
          stars: 0,
          isLocked: true,
        );
      }
    });

    final mapLevels = allLevels.sublist(start, end);

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! < -200 && currentMapIndex < mapAssets.length - 1) {
            // Swipe kiri (next)
            setState(() {
              currentMapIndex++;
            });
          } else if (details.primaryVelocity! > 200 && currentMapIndex > 0) {
            // Swipe kanan (prev)
            setState(() {
              currentMapIndex--;
            });
          }
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: Stack(
          key: ValueKey(currentMapIndex),
          children: [
            // Background peta
            Positioned.fill(
              child: Image.asset(mapAssets[currentMapIndex], fit: BoxFit.cover),
            ),
            // Level layout dengan snake pattern
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Tombol next (kanan atas)
                    if (currentMapIndex < mapAssets.length - 1 && levelsPerMap[currentMapIndex] > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: NextButtonMap(
                            onTap: () {
                              setState(() {
                                currentMapIndex++;
                              });
                            },
                          ),
                        ),
                      ),
                    // Level rows
                    ...(_buildLevelRows(mapLevels, lessons)),
                    // Tombol prev (kiri bawah)
                    if (currentMapIndex > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: PreviousButtonMap(
                            onTap: () {
                              setState(() {
                                currentMapIndex--;
                              });
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLevelRows(List<Level> levels, List<Lesson> lessons) {
    // Jika tidak ada level, return empty
    if (levels.isEmpty) {
      return [
        Center(
          child: Text(
            'Peta ini belum tersedia',
            style: TextStyle(fontSize: 18, color: Colors.brown),
          ),
        ),
      ];
    }

    List<Widget> rows = [];
    int levelIndex = 0;
    int rowIndex = 0;

    while (levelIndex < levels.length) {
      // Ambil 3 level atau kurang untuk baris ini
      final rowLevels = levels.skip(levelIndex).take(3).toList();
      levelIndex += rowLevels.length;

      // Tentukan apakah baris ini dibalik (snake pattern)
      final isReversed = rowIndex % 2 == 1;
      final displayLevels =
          isReversed ? rowLevels.reversed.toList() : rowLevels;

      // Buat row dengan level saja (tanpa navigasi di dalam row)
      List<Widget> rowChildren = [];

      // Tambahkan level-level
      for (int i = 0; i < displayLevels.length; i++) {
        final level = displayLevels[i];

        if (i > 0) {
          rowChildren.add(SizedBox(width: _getSpacing(rowIndex, i)));
        }

        rowChildren.add(_buildLevelWidget(level, lessons));
      }

      // Buat row dengan posisi yang bervariasi
      rows.add(
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: _getRowHorizontalPadding(rowIndex),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rowChildren,
          ),
        ),
      );

      rowIndex++;
    }

    // Balik urutan rows agar level 1 di bawah (seperti snake pattern)
    return rows.reversed.toList();
  }

  Widget _buildLevelWidget(Level level, List<Lesson> lessons) {
    return level.isLocked
        ? LevelLocked(level: level)
        : LevelUnlocked(
          level: level,
          onTap: () => _navigateToLesson(ref, lessons[level.level - 1]),
        );
  }

  double _getSpacing(int rowIndex, int levelIndex) {
    // Variasi spacing berdasarkan pola snake dan posisi
    if (rowIndex % 2 == 0) {
      // Baris normal
      return 20.0 + (levelIndex * 5.0);
    } else {
      // Baris terbalik
      return 25.0 + (levelIndex * 3.0);
    }
  }

  double _getRowHorizontalPadding(int rowIndex) {
    // Variasi posisi horizontal untuk memberikan efek organic
    switch (rowIndex % 4) {
      case 0:
        return 0.0;
      case 1:
        return 20.0;
      case 2:
        return 10.0;
      case 3:
        return 30.0;
      default:
        return 0.0;
    }
  }

  void _navigateToLesson(WidgetRef ref, Lesson lesson) {
    try {
      ref.read(lessonGameProvider.notifier).setLesson(lesson);
      Get.toNamed(RouteName.questions);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
