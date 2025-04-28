import 'package:flutter/material.dart';
import 'package:adibasa_app/dummy/levels_dummy.dart';

class LevelUnlocked extends StatelessWidget {
  final Level level;
  const LevelUnlocked({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF1DFBE), // match Card color
          border: Border.all(
            color: const Color(
              0xFF7F833A,
            ), // deeper brown for more visual weight
            width: 1, // make it thicker
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7F833A),
              // spreadRadius: 1,
              // blurRadius: 1,
              offset: Offset(1, 2),
            ),
          ],
        ),
        child: Card(
          color: const Color(0xFFF1DFBE),
          // elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                // leading: const Icon(Icons.book, size: 50),
                title: Text(
                  '${level.name}:', // <-- Level name
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF61450F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  level.description, // <-- Level description
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF634311),
                  ),
                ),
                trailing: Image.asset(
                  'assets/${level.stars}_stars.png', // <-- GANTI ICON BERDASARKAN STARS
                  height: 80,
                  width: 80,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
