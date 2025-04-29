import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/star_provider.dart';
import '../providers/streak_provider.dart';
import '../widgets/star_rating.dart';

class LevelCompletePage extends StatelessWidget {
  const LevelCompletePage({Key? key}) : super(key: key);

  // Widget helper untuk membuat tombol
  Widget _buildButton(BuildContext context, double width, double height, IconData icon, String label, VoidCallback onPressed) {
    return Container(
      width: width,
      height: height,
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
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black87),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

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
                'Level Selesai!',
                style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold
                )
            ),

            // Karakter/gambar - proporsi sekitar 30% tinggi layar
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.03),
              height: screenHeight * 0.3,
              child: Image.asset(
                'assets/images/icon.png',
                fit: BoxFit.contain,
              ),
            ),

            // Informasi bintang
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.02),
              child: Text(
                  'Bintang didapat: $star',
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

            // Spacer menggunakan Expanded
            Expanded(child: Container()),

            // Tiga tombol sejajar horizontal
            Container(
              margin: EdgeInsets.only(bottom: screenHeight * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tombol 1
                  _buildButton(
                    context,
                    screenWidth * 0.25,
                    screenHeight * 0.06,
                    Icons.home,
                    'Home',
                        () => Navigator.of(context).popUntil((route) => route.isFirst),
                  ),

                  // Jarak antar tombol
                  SizedBox(width: screenWidth * 0.04),

                  // Tombol 2
                  _buildButton(
                    context,
                    screenWidth * 0.25,
                    screenHeight * 0.06,
                    Icons.refresh,
                    'Ulangi',
                        () => Navigator.of(context).pop(),
                  ),

                  // Jarak antar tombol
                  SizedBox(width: screenWidth * 0.04),

                  // Tombol 3
                  _buildButton(
                    context,
                    screenWidth * 0.25,
                    screenHeight * 0.06,
                    Icons.arrow_forward,
                    'Lanjut',
                        () {
                      // Navigasi ke level berikutnya
                      // Implementasi sesuai kebutuhan
                      Navigator.of(context).pop();
                    },
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