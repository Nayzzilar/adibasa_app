import 'package:flutter/material.dart';

class NewWordPopup extends StatelessWidget {
  final String word;
  final String meaning;
  final Offset position;
  final VoidCallback? onClose;

  const NewWordPopup({
    Key? key,
    required this.word,
    required this.meaning,
    required this.position,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.35,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFFFA726),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                word,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFFA726),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                meaning,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  color: Color(0xFF4A4A4A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
