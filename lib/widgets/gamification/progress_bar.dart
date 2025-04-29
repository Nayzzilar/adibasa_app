import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final int streak;
  final VoidCallback? onClose;

  const ProgressBar({
    Key? key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.streak,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    double progress = currentQuestion / totalQuestions;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 44, 20, 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
            tooltip: 'Keluar',
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = constraints.maxWidth;
                // Hitung posisi horizontal angka soal
                double min = 0;
                double max = barWidth;
                double pos = min + (max - min) * ((currentQuestion - 1) / (totalQuestions - 1).clamp(1, double.infinity));
                // Clamp agar tidak keluar bar
                pos = pos.clamp(min, max - 28);
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: colorScheme.surfaceContainer,
                        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                        minHeight: 12,
                      ),
                    ),
                    Positioned(
                      left: pos,
                      top: -8,
                      child: Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD2B48C),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: colorScheme.primary, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '$currentQuestion',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Image.asset(
            'assets/image/FireStreak.png',
            width: 22,
            height: 22,
          ),
          const SizedBox(width: 4),
          Text('$streak', style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
} 