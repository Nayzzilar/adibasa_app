import 'package:adibasa_app/navigation/bottom_navbar.dart';
import 'package:adibasa_app/widgets/level_locked.dart';
import 'package:adibasa_app/widgets/status_bar_level_selection.dart';
import 'package:adibasa_app/navigation/buttom_navbar.dart';
import 'package:adibasa_app/widgets/level_selection/level_locked.dart';
import 'package:adibasa_app/widgets/level_selection/status_bar_level_selection.dart';
import 'package:flutter/material.dart';
import 'package:adibasa_app/widgets/level_selection/level_unlocked.dart';
import 'package:adibasa_app/dummy/levels_dummy.dart';
import 'package:adibasa_app/models/level.dart';


class LevelSelection extends StatelessWidget {
  const LevelSelection({super.key});

  @override
  Widget build(BuildContext context) {
    List<Level> levels = getLevels();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
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
                return levels[index].isLocked
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
