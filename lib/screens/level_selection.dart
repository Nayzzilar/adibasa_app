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

  //SliverList _buildLevelsList(
      //WidgetRef ref, List<Lesson> lessons, LessonGameState gameState) {
    // Di masa depan kita bisa menggunakan gameState untuk menentukan level mana yang terbuka
    // dan berapa bintang yang ada di setiap level

    // Convert lessons to levels with all unlocked
  SliverList _buildLevelsList(WidgetRef ref, List<Lesson> lessons) {
    final userData = ref.watch(userDataProvider);

    final levels =
        lessons.map((lesson) {
          // Level 1 pasti terbuka
          final isFirstLevel = lesson.order == 1;
          // Level sebelumnya harus sudah selesai untuk membuka level selanjutnya
          final isLocked =
              !isFirstLevel &&
              !userData.lessonStars.containsKey(lesson.order - 1);
          // Berapa bintang level ini
          final stars = userData.lessonStars[lesson.order] ?? 0;

          return Level(
            level: lesson.order,
            name: "Level ${lesson.order}",
            description: lesson.title,
            stars: stars,
            isLocked: isLocked,
          );
        }).toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final level = levels[index];
        return level.isLocked
            ? LevelLocked(level: level)
            : InkWell(
              onTap: () => _navigateToLesson(ref, lessons[index]),
              child: LevelUnlocked(level: level),
            );
      }, childCount: levels.length),
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
