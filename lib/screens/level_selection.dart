import 'package:adibasa_app/models/level.dart';
import 'package:adibasa_app/providers/lessons_provider.dart';
import 'package:adibasa_app/screens/multiple_choice_page.dart';
import 'package:adibasa_app/theme/theme.dart';
import 'package:adibasa_app/widgets/level_selection/level_locked.dart';
import 'package:adibasa_app/widgets/level_selection/status_bar_level_selection.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:adibasa_app/widgets/level_unlocked.dart';
import 'package:adibasa_app/dummy/levels_dummy.dart';
import 'package:adibasa_app/widgets/level_appbar.dart';
import 'package:adibasa_app/models/level.dart';
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
      backgroundColor: const Color(0xFFF1DFBE),
      body: Column(
        children: [
          const LevelAppBar(),
          // Padding( (padding ini dipake kalo rizal berubah pikiran jadi ga usah dihapus hehe)
          //   padding: const EdgeInsets.only(
          //     right: 16,
          //     left: 16,
          //     top: 40,
          //     //bottom: 50,
          //   ),
          //   child: Card(
          //     color: const Color(0xFFF1DFBE),
          //     elevation: 2,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     child: Container(
          //       padding: const EdgeInsets.only(
          //         right: 20,
          //         // left: 16,
          //         top: 12,
          //         bottom: 12,
          //       ),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Row(
          //             children: [
          //               Image.asset('assets/streak.png', height: 30, width: 30),
          //               const SizedBox(width: 4),
          //               const Text(
          //                 '5',
          //                 style: TextStyle(
          //                   fontSize: 32,
          //                   fontWeight: FontWeight.bold,
          //                   color: Color(0xFF61450F),
          //                 ),
          //               ),
          //               const SizedBox(width: 12),
          //               Image.asset('assets/star.png', height: 30, width: 30),
          //               const SizedBox(width: 4),
          //               const Text(
          //                 '12',
          //                 style: TextStyle(
          //                   fontSize: 32,
          //                   fontWeight: FontWeight.bold,
          //                   color: Color(0xFF61450F),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           const Text(
          //             'Level 3/50',
          //             style: TextStyle(
          //               fontSize: 26,
          //               fontWeight: FontWeight.bold,
          //               color: Color(0xFF61450F),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            child: ListView.builder(
              //padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: levels.length,
              itemBuilder: (context, index) {
                return levels[index].is_locked
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Sliver untuk StatusBarLevelSelection
            SliverToBoxAdapter(
              child: Column(children: [StatusBarLevelSelection()]),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return levels[index].isLocked
                    ? LevelLocked(level: levels[index])
                    : LevelUnlocked(
                      level: levels[index],
                    ); // <-- PASSED LEVEL DATA
              },
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
                  onTap: () => _navigateToLesson(ref,lessons[index]),
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
