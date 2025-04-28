import 'package:flutter/material.dart';

class NewWordPopup extends StatelessWidget {
  final String word;
  final String meaning;
  final Offset? position;

  const NewWordPopup({
    Key? key,
    required this.word,
    required this.meaning,
    this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        Positioned(
          left: position?.dx ?? 100,
          top: position?.dy ?? 100,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1), // kuning muda
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Color(0xFFFFA726), width: 2), // oranye
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    word,
                    style: TextStyle(
                      color: Color(0xFFFFA726),
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    meaning,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF61450F),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
} 