import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/lesson_game_provider.dart'; // Ganti import provider
import '../widgets/star_rating.dart';
import '../navigation/route_name.dart';
import 'package:get/get.dart';
import 'package:adibasa_app/theme/theme.dart';

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

    // Mendapatkan state dari lessonGameProvider
    final gameState = ref.read(lessonGameProvider);
    final stars = gameState.stars;
    final duration = gameState.duration;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.16),
              height: 345.5,
              width: 258.5,
              child: Image.asset(
                'assets/images/badak_tepuk_tangan.png',
                fit: BoxFit.contain,
              ),
            ),

            /*Text(
              'Level ${gameState.currentLesson?.order ?? ""} telah diselesaikan!',
              style: TextStyle(
                fontSize: screenWidth * 0.055,
                fontWeight: FontWeight.bold,
              ),
            ),*/
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.access_time, size: screenWidth * 0.07),
                  SizedBox(
                    width: screenWidth * 0.015,
                  ), // sedikit jarak antara ikon dan teks
                  Text(
                    formatDuration(duration),
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.02),
              height: screenHeight * 0.15,
              child: StarRating(
                starCount: stars,
                size: screenWidth * 0.2,
                spacing: screenWidth * 0.02,
              ),
            ),

            /*Container(
              margin: EdgeInsets.only(bottom: screenHeight * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIconButton(
                    context,
                    Icons.home_outlined,
                    () => Get.offAllNamed(RouteName.bottomNavbar),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  /*_buildIconButton(
                    context,
                    Icons.refresh,
                    () => _replayLesson(ref),
                  ),*/
                  SizedBox(width: screenWidth * 0.04),
                  /*_buildIconButton(
                    context,
                    Icons.double_arrow,
                    () => _nextLesson(ref),
                  ),*/
                ],
              ),
            ),
            */
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.06),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: CustomColors.buttonColor.withOpacity(1.0),
                    offset: Offset(0, 6), // arah dan jarak bayangan
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Get.offAllNamed(RouteName.bottomNavbar);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.tertiary,
                      width: 2.0,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  minimumSize: Size(330, 48),
                  backgroundColor: CustomColors.borderButton,
                  foregroundColor: Colors.white,
                  elevation: 0, // penting agar tidak dobel shadow
                ),
                child: Text(
                  'Lanjutkan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*Widget _buildIconButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.15,
      height: screenWidth * 0.06, // lebih pipih seperti di gambar
      decoration: BoxDecoration(
        color: const Color(0xFF9BA85B), // warna mirip olive green
        borderRadius: BorderRadius.circular(30), // membuatnya oval/kapsul
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.tertiary,
            offset: const Offset(0, 3),
            blurRadius: 0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: IconButton(
          icon: Icon(icon, color: Colors.white), // ikon putih
          iconSize: screenWidth * 0.045,
          padding: EdgeInsets.zero, // menghilangkan padding default
          onPressed: onPressed,
        ),
      ),
    );
  }*/
}
