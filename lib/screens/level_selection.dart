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
            // Sliver untuk StatusBarLevelSelection
            SliverToBoxAdapter(
              child: Column(
                children: [
                  StatusBarLevelSelection(),
                  // Padding( (padding ini dipake kalo rizal berubah pikiran jadi ga usah dihapus)
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
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
