import 'package:flutter/material.dart';
import 'package:adibasa_app/theme/theme.dart';

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
    final theme = Theme.of(context);
    final feedbackColors = theme.extension<FeedbackColors>();

    if (feedbackColors == null) {
      throw Exception('FeedbackColors extension not found in theme');
    }

    final backgroundColor =
        isCorrect
            ? feedbackColors.correctBackground
            : feedbackColors.wrongBackground;

    final foregroundColor =
        isCorrect
            ? feedbackColors.correctForeground
            : feedbackColors.wrongForeground;

    final buttonColor =
        isCorrect ? feedbackColors.correctButton : feedbackColors.wrongButton;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outline, width: 4),
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
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: foregroundColor,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                isCorrect ? 'Anda Benar' : 'Anda Salah',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: foregroundColor,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Jawaban yang benar:',
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
          ),
          Text(
            correctAnswer,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Lanjutkan',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedResultDialog extends StatefulWidget {
  final bool isCorrect;
  final String correctAnswer;
  final VoidCallback onContinue;

  const AnimatedResultDialog({
    Key? key,
    required this.isCorrect,
    required this.correctAnswer,
    required this.onContinue,
  }) : super(key: key);

  @override
  State<AnimatedResultDialog> createState() => _AnimatedResultDialogState();
}

class _AnimatedResultDialogState extends State<AnimatedResultDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scaleAnim = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: ResultDialog(
          isCorrect: widget.isCorrect,
          correctAnswer: widget.correctAnswer,
          onContinue: widget.onContinue,
        ),
      ),
    );
  }
}
