import 'package:flutter/material.dart';

class ResultDialog extends StatelessWidget {
  final bool isCorrect;
  final String correctAnswer;
  final VoidCallback onContinue;

  const ResultDialog({
    Key? key,
    required this.isCorrect,
    required this.correctAnswer,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: isCorrect ? const Color(0xFFE6F4EA) : const Color(0xFFFFE6E6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                isCorrect ? 'assets/image/AndaBenar.png' : 'assets/image/AndaSalah.png',
                width: 28,
                height: 28,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'Anda Benar' : 'Anda Salah',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Jawaban yang benar:', style: textTheme.bodyMedium),
          Text(
            correctAnswer,
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Lanjutkan'),
            ),
          ),
        ],
      ),
    );
  }
} 