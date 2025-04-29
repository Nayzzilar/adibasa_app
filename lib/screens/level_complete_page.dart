import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/star_provider.dart';
import '../providers/streak_provider.dart';
import '../widgets/star_rating.dart';

class LevelCompletePage extends StatelessWidget {
  const LevelCompletePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final streak = Provider.of<StreakProvider>(context, listen: false).streak;
    final star = 3;

    return Scaffold(
      backgroundColor: const Color(0xFFF8ECC2), // Warna background sesuai dengan screenshot
      body: Center(
        child: Column(
          children: [
            // Area untuk status bar
            Container(height: screenHeight * 0.05),

            // Judul di bagian atas
            Text(
                'Level telah diselesaikan!',
                style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold
                )
            ),

            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.1),
              height: screenHeight * 0.4,
              width: screenWidth * 0.9,
              child: Image.asset(
                'assets/images/icon.png',
                fit: BoxFit.contain,
              ),
            ),

            // Informasi bintang
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.02),
              child: Text(
                  '01:30',
                  style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w500
                  )
              ),
            ),

            // Tampilan bintang - proporsi sekitar 15% tinggi layar
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.02),
              height: screenHeight * 0.15,
              child: StarRating(
                starCount: star,
                size: screenWidth * 0.2,
                spacing: screenWidth * 0.04,
              ),
            ),

            // Tiga tombol sejajar horizontal
            Container(
              margin: EdgeInsets.only(bottom: screenHeight * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tombol Home - IconButton dalam Container
                  Container(
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
                      icon: const Icon(Icons.home, color: Colors.black87),
                      iconSize: screenWidth * 0.06,
                      onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    ),
                  ),

                  // Jarak antar tombol
                  SizedBox(width: screenWidth * 0.04),

                  // Tombol Refresh
                  Container(
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
                      icon: const Icon(Icons.refresh, color: Colors.black87),
                      iconSize: screenWidth * 0.06,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),

                  // Jarak antar tombol
                  SizedBox(width: screenWidth * 0.04),

                  // Tombol Next
                  Container(
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
                      icon: const Icon(Icons.arrow_forward, color: Colors.black87),
                      iconSize: screenWidth * 0.06,
                      onPressed: () {
                        // Navigasi ke level berikutnya
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}