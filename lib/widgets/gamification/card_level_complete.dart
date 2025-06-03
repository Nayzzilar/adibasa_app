// widgets/card_level_complete.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/lesson_game_provider.dart'; // Ganti import provider
import 'package:adibasa_app/theme/theme.dart';

class CardLevelComplete extends ConsumerWidget {
  final Duration duration;
  final int correctPercentage;

  const CardLevelComplete({
    Key? key,
    required this.duration,
    required this.correctPercentage,
  }) : super(key: key);

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final gameState = ref.read(lessonGameProvider);

    return Container(
      width: screenWidth * 1.3,
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.1,
        vertical: screenHeight * 0.0008,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline, // Warna border
          width: 4, // Ketebalan border
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.004,
              horizontal: screenWidth * 0.004,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Text(
              'Level ${gameState.currentLesson?.order ?? ""} Telah Diselesaikan!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: screenWidth * 0.055,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Content
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Waktu Section
              Expanded(
                child: _buildInfoColumn(
                  context,
                  Icons.access_time,
                  'Waktu',
                  formatDuration(duration),
                ),
              ),

              // Garis pemisah (divider vertikal)
              /*Container(
                width: 1,
                height: screenWidth * 0.2, // sesuaikan tinggi
                color: Colors.grey.withOpacity(0.3),
              ),*/

              // Score Section
              Expanded(
                child: _buildInfoColumn(
                  context,
                  Icons.check,
                  'Score',
                  '${correctPercentage.toStringAsFixed(0)}%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        // Icon dan Title dalam Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth * 0.015),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: screenWidth * 0.05,
              ),
            ),

            SizedBox(width: screenWidth * 0.02),

            Text(
              title,
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),

        SizedBox(height: screenWidth * 0.02),

        // Value di bawah
        Text(
          value,
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
