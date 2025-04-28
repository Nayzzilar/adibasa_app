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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: isCorrect ? const Color(0xFFE6F4EA) : const Color(0xFFFFE6E6),
        borderRadius: BorderRadius.circular(18),
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
                color: isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                isCorrect ? 'Anda Benar' : 'Anda Salah',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                  fontSize: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text('Jawaban yang benar:', style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
          Text(
            correctAnswer,
            style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: isCorrect ? const Color(0xFF4B6B2D) : const Color(0xFFA13A2C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: const Text('Lanjutkan'),
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

class _AnimatedResultDialogState extends State<AnimatedResultDialog> with SingleTickerProviderStateMixin {
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
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
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