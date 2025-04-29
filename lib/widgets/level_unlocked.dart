import 'package:flutter/material.dart';
import '../models/level.dart';
import '../widgets/star_rating.dart'; // Import widget StarRating kita

class LevelUnlocked extends StatelessWidget {
  final Level level;
  const LevelUnlocked({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF1DFBE),
          border: Border.all(
            color: const Color(0xFF7F833A),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF7F833A),
              offset: Offset(1, 2),
            ),
          ],
        ),
        child: Card(
          color: const Color(0xFFF1DFBE),
          shadowColor: Colors.black.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Kolom untuk judul dan deskripsi level
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${level.name}:', // Menggunakan title alih-alih name
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF61450F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        level.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF634311),
                        ),
                      ),
                    ],
                  ),
                ),

                // Widget bintang di sisi kanan
                Expanded(
                  flex: 3,
                  child: StarRating(
                    starCount: level.stars ?? 0,
                    size: 22,
                    spacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}