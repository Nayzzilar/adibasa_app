import 'package:flutter/material.dart';

class LevelAppBar extends StatelessWidget {
  const LevelAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      child: Container(
        color: const Color(0xFFF1DFBE),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        margin: const EdgeInsets.only(top: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                    children: [
                      Image.asset('assets/streak.png', height: 30, width: 30),
                      const SizedBox(width: 4),
                      const Text(
                        '5',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF61450F),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Image.asset('assets/star.png', height: 30, width: 30),
                      const SizedBox(width: 4),
                      const Text(
                        '12',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF61450F),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                'Level 3/50',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF61450F),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
