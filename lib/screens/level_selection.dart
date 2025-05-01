import 'package:adibasa_app/models/level.dart';
import 'package:adibasa_app/providers/lessons_provider.dart';
import 'package:adibasa_app/widgets/level_selection/level_locked.dart';
import 'package:adibasa_app/widgets/level_selection/status_bar_level_selection.dart';
import 'package:flutter/material.dart';
import 'package:adibasa_app/widgets/level_selection/level_unlocked.dart';
import 'package:adibasa_app/models/lesson_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../navigation/route_name.dart';
import '../providers/current_lesson_provider.dart';

class LevelSelection extends ConsumerWidget {
  const LevelSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(lessonsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Column(children: [StatusBarLevelSelection()]),
            ),
            lessonsAsync.when(
              loading:
                  () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
              error:
                  (error, stack) => SliverFillRemaining(
                    child: Center(child: Text('Error: $error')),
                  ),
              data: (lessons) => _buildLevelsList(ref, lessons),
            ),
          ],
        ),
      ),
    );
  }

  SliverList _buildLevelsList(ref, List<Lesson> lessons) {
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
    ref.read(currentLessonProvider.notifier).setLesson(lesson);
    Get.toNamed(RouteName.questions);
  }
}
