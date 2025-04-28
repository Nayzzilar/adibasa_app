import 'package:adibasa_app/widgets/status_bar_level_selection.dart';
import 'package:flutter/material.dart';
import 'package:adibasa_app/dummy/levels_dummy.dart';
import 'package:adibasa_app/widgets/level_locked.dart';
import 'package:adibasa_app/widgets/level_unlocked.dart';

class LevelSelectionPage extends StatelessWidget {
  const LevelSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Level> levels = Level.getLevels();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const StatusBarLevelSelection(),
            Expanded(
              child: ListView.builder(
                itemCount: levels.length,
                itemBuilder: (context, index) {
                  return levels[index].is_locked
                      ? LevelLocked(level: levels[index])
                      : LevelUnlocked(level: levels[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
