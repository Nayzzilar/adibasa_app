import 'package:adibasa_app/models/level.dart';
import 'package:adibasa_app/providers/lessons_provider.dart';
import 'package:adibasa_app/widgets/level_selection/level_locked.dart';
import 'package:adibasa_app/widgets/level_selection/status_bar_level_selection.dart';
import 'package:flutter/material.dart';
import 'package:adibasa_app/widgets/level_selection/level_unlocked.dart';
import 'package:adibasa_app/models/lesson_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:adibasa_app/navigation/route_name.dart';
import 'package:adibasa_app/providers/lesson_game_provider.dart';

class LevelSelection extends ConsumerWidget {
  const LevelSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(lessonsProvider);
    // Kita juga bisa mengamati state game jika dibutuhkan
    final gameState = ref.watch(lessonGameProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Fixed status bar using SliverPersistentHeader with pinned: true
            SliverPersistentHeader(
              pinned: true, // This makes it stick to the top when scrolling
              delegate: _SliverStatusBarDelegate(
                child: const StatusBarLevelSelection(),
              ),
            ),

            // Lessons content
            lessonsAsync.when(
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => SliverFillRemaining(
                child: Center(child: Text('Error: $error')),
              ),
              data: (lessons) => _buildLevelsList(ref, lessons, gameState),
            ),
          ],
        ),
      ),
    );
  }

  SliverList _buildLevelsList(
      WidgetRef ref, List<Lesson> lessons, LessonGameState gameState) {
    // Di masa depan kita bisa menggunakan gameState untuk menentukan level mana yang terbuka
    // dan berapa bintang yang ada di setiap level

    // Convert lessons to levels with all unlocked
    final levels =
        lessons
            .map(
              (lesson) => Level(
                level: lesson.order,
                name: "Level ${lesson.order}",
                description: lesson.title,
                stars: 1,
                isLocked: false, // Temporary override
              ),
            )
            .toList();

    levels.addAll([
      Level(
        level: levels.length + 1,
        name: "Level ${levels.length + 1}",
        description: "Locked level",
        stars: 0,
        isLocked: true,
      ),
      Level(
        level: levels.length + 2,
        name: "Level ${levels.length + 2}",
        description: "Locked level",
        stars: 0,
        isLocked: true,
      ),
      Level(
        level: levels.length + 3,
        name: "Level ${levels.length + 3}",
        description: "Locked level",
        stars: 0,
        isLocked: true,
      ),
      Level(
        level: levels.length + 4,
        name: "Level ${levels.length + 4}",
        description: "Locked level",
        stars: 0,
        isLocked: true,
      ),
      Level(
        level: levels.length + 5,
        name: "Level ${levels.length + 5}",
        description: "Locked level",
        stars: 0,
        isLocked: true,
      ),
    ]);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) =>
            levels[index].isLocked
                ? LevelLocked(level: levels[index])
                : InkWell(
                  onTap: () => _navigateToLesson(ref, lessons[index]),
                  child: LevelUnlocked(level: levels[index]),
                ),
        childCount: levels.length,
      ),
    );
  }

  void _navigateToLesson(WidgetRef ref, Lesson lesson) {
    try {
      // Langsung set lesson dulu
      ref.read(lessonGameProvider.notifier).setLesson(lesson);

      // Kemudian navigasi ke halaman questions
      Get.toNamed(RouteName.questions);
    } catch (e) {
      // Tampilkan pesan error jika terjadi masalah
      SnackBar(content: Text('Error: $e'));
    }
  }
}

// Custom delegate for the fixed status bar
class _SliverStatusBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverStatusBarDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Add background color to match the scaffold background
    return Container(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: child,
    );
  }

  @override
  double get maxExtent => 85.0; // Adjust the height based on your status bar height

  @override
  double get minExtent => 85.0; // Usually the same as maxExtent for a fixed header

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
