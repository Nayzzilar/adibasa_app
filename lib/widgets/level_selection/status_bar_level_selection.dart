import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StatusBarLevelSelection extends StatelessWidget {
  const StatusBarLevelSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: DefaultTextStyle(
            style:
                Theme.of(
                  context,
                ).textTheme.headlineLarge!, // Gunakan gaya teks dari TextTheme
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Bagian Kiri
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/streak.svg', // Path ke gambar
                      width: 20, // Sesuaikan ukuran gambar
                      height: 33,
                    ),
                    const SizedBox(width: 5),
                    const Text('5'), // Gaya teks otomatis diterapkan
                    const SizedBox(width: 20),
                    SvgPicture.asset('assets/star/star_active.svg'),
                    const SizedBox(width: 5),
                    const Text('5'), // Gaya teks otomatis diterapkan
                  ],
                ),

                // Bagian Kanan
                const Text('Level 3/50'), // Gaya teks otomatis diterapkan
              ],
            ),
          ),
        ),
      ),
    );
  }
}
