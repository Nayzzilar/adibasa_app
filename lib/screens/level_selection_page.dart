import 'package:adibasa_app/widgets/status_bar_level_selection.dart';
import 'package:flutter/material.dart';

class LevelSelectionPage extends StatelessWidget {
  const LevelSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(children: [StatusBarLevelSelection()]),
            ),
          ],
        ),
      ),
    );
  }
}
