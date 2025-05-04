import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/star_provider.dart';
import '../providers/duration_provider.dart';
import '../widgets/star_rating.dart';
import '../navigation/route_name.dart';
import 'package:get/get.dart';
import '../providers/current_lesson_provider.dart';

class LevelCompletePage extends ConsumerWidget {
  const LevelCompletePage({Key? key}) : super(key: key);

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

    // Get provider values
    final star = ref.read(starProvider);
    final duration = ref.read(durationProvider);

    // Tambahkan method baru di class LevelCompletePage
    void _replayLesson(WidgetRef ref) {
      // Reset semua state terkait lesson
      ref.read(durationProvider.notifier).reset();

      // Navigasi ke halaman questions dengan state segar
      Get.offAllNamed(RouteName.questions);
    }

    void _nextLesson(WidgetRef ref) {
      final currentLesson = ref.read(currentLessonProvider);
      final nextLesson =
          ref.read(currentLessonProvider.notifier).getNextLesson();

      if (nextLesson != null) {
        // Reset state
        ref.read(durationProvider.notifier).reset();

        // Set lesson berikutnya
        ref.read(currentLessonProvider.notifier).setLesson(nextLesson);
        Get.offAllNamed(RouteName.questions);
      } else {
        // Tampilkan dialog atau navigasi ke level selection
        Get.offAllNamed(RouteName.levelSelection);
        Get.snackbar('Selamat!', 'Anda telah menyelesaikan semua level');
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8ECC2),
      body: Center(
        child: Column(
          children: [
            Container(height: screenHeight * 0.05),

            Text(
              'Level telah diselesaikan!',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.1),
              height: screenHeight * 0.4,
              width: screenWidth * 0.9,
              child: Image.asset('assets/images/icon.png', fit: BoxFit.contain),
            ),

            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.02),
              child: Text(
                'Waktu: ${formatDuration(duration)}',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.02),
              height: screenHeight * 0.15,
              child: StarRating(
                starCount: star,
                size: screenWidth * 0.2,
                spacing: screenWidth * 0.04,
              ),
            ),

            Container(
              margin: EdgeInsets.only(bottom: screenHeight * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIconButton(
                    context,
                    Icons.home,
                    () => Get.offAllNamed(RouteName.levelSelection),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  _buildIconButton(
                    context,
                    Icons.refresh,
                    () => _replayLesson(ref),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  _buildIconButton(
                    context,
                    Icons.arrow_forward,
                    () => _nextLesson(ref),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.15,
      height: screenWidth * 0.15,
      decoration: BoxDecoration(
        color: const Color(0xFFB3C27C),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black87),
        iconSize: screenWidth * 0.06,
        onPressed: onPressed,
      ),
    );
  }
}
