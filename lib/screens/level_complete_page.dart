import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/lesson_game_provider.dart';
import '../widgets/star_rating.dart';
import '../widgets/gamification/card_level_complete.dart'; // Import widget CompleteCard yang baru
import '../navigation/route_name.dart';
import 'package:get/get.dart';

class LevelCompletePage extends ConsumerWidget {
  const LevelCompletePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Mendapatkan state dari lessonGameProvider
    final gameState = ref.read(lessonGameProvider);
    final stars = gameState.stars;
    final duration = gameState.duration;

    // Hitung persentase jawaban benar
    final correctPercentage = gameState.percentage;

    // Tambahkan method untuk replay lesson
    void _replayLesson(WidgetRef ref) {
      Future.microtask(() {
        final gameNotifier = ref.read(lessonGameProvider.notifier);
        gameNotifier.resetTimer();
        Get.offAllNamed(RouteName.questions);
      });
    }

    void _nextLesson(WidgetRef ref) {
      Future.microtask(() {
        final gameNotifier = ref.read(lessonGameProvider.notifier);
        final nextLesson = gameNotifier.getNextLesson();

        if (nextLesson != null) {
          gameNotifier.setLesson(nextLesson);
          Get.offAllNamed(RouteName.questions);
        } else {
          Get.offAllNamed(RouteName.bottomNavbar);
          Get.snackbar('Selamat!', 'Anda telah menyelesaikan semua level');
        }
      });
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.06),

              // Image
              Container(
                height: screenHeight * 0.38,
                width: screenWidth * 0.9,
                child: Image.asset(
                  'assets/images/icon.png',
                  fit: BoxFit.contain,
                ),
              ),

              // Star Rating
              Container(
                height: screenHeight * 0.15,
                child: StarRating(
                  starCount: stars,
                  size: screenWidth * 0.2,
                ),
              ),

              // Complete Card
              CardLevelComplete(
                duration: duration,
                correctPercentage: correctPercentage,
              ),

              SizedBox(height: screenHeight * 0.04),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          width: screenWidth * 0.18,
          height: screenWidth * 0.18,
          decoration: BoxDecoration(
            color: const Color(0xFF9BA85B),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9BA85B).withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onPressed,
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: screenWidth * 0.08,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
