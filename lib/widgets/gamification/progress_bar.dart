import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
    double progress = currentQuestion / totalQuestions;
    final color = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 28, 20, 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF61450F)),
            onPressed: onClose,
            tooltip: 'Keluar',
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.primaryContainer,
              valueColor: AlwaysStoppedAnimation<Color>(
                color.tertiaryContainer,
              ),
              minHeight: 14,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          SvgPicture.asset('assets/images/streak.svg', width: 22, height: 22),
          const SizedBox(width: 4),
          Text(
            '$streak',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF61450F),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
