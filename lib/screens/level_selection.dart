import 'package:adibasa_app/navigation/bottom_navbar.dart';
import 'package:adibasa_app/widgets/level_locked.dart';
import 'package:adibasa_app/widgets/status_bar_level_selection.dart';
import 'package:flutter/material.dart';
import 'package:adibasa_app/widgets/level_unlocked.dart';
import 'package:adibasa_app/dummy/levels_dummy.dart';

class LevelSelection extends StatelessWidget {
  const LevelSelection({super.key});

  @override
  Widget build(BuildContext context) {
    List<Level> levels = Level.getLevels();
    return Scaffold(
      backgroundColor: const Color(0xFFF1DFBE),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  StatusBarLevelSelection(),
                ],
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return levels[index].is_locked
                    ? LevelLocked(level: levels[index])
                    : LevelUnlocked(level: levels[index]);
              }, childCount: levels.length),
            ),
          ],
        ),
      ),
    );
  }
}
