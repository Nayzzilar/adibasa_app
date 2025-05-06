import 'package:flutter/material.dart';
import 'dart:math';

class ProgressBar extends StatefulWidget {
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
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with TickerProviderStateMixin {
  int _lastStreak = 0;
  int _lastQuestion = 0;
  late AnimationController _sparkleController;
  late Animation<double> _sparkleAnim;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _lastStreak = widget.streak;
    _lastQuestion = widget.currentQuestion;
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _sparkleAnim = CurvedAnimation(
      parent: _sparkleController,
      curve: Curves.easeOut,
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _pulseAnim = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeOut,
    );
  }

  @override
  void didUpdateWidget(covariant ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.streak > _lastStreak) {
      _sparkleController.forward(from: 0);
    }
    _lastStreak = widget.streak;
    if (widget.currentQuestion != _lastQuestion) {
      _pulseController.forward(from: 0);
    }
    _lastQuestion = widget.currentQuestion;
  }

  @override
  void dispose() {
    _sparkleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 28, 20, 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF61450F)),
            onPressed: widget.onClose,
            tooltip: 'Keluar',
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = constraints.maxWidth;
                double progress =
                    (widget.currentQuestion - 1) /
                    (widget.totalQuestions - 1).clamp(1, double.infinity);
                double circleOffset;
                if (widget.currentQuestion == 1 ||
                    widget.currentQuestion == widget.totalQuestions) {
                  circleOffset = 0;
                } else {
                  circleOffset = 5;
                }
                double circleLeft =
                    (barWidth * progress).clamp(0, barWidth - 28) -
                    circleOffset;
                return SizedBox(
                  height: 36,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // Bar coklat penuh
                      Positioned(
                        top: 9,
                        child: Container(
                          width: barWidth,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B4711),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      // Bar hijau (progress)
                      Positioned(
                        top: 9,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                          width: barWidth * progress,
                          height: 14,
                          decoration: const BoxDecoration(
                            color: Color(0xFF5E661F),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                      // Lingkaran nomor soal
                      Positioned(
                        left: circleLeft,
                        top: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF61450F),
                              width: 2.5,
                            ),
                          ),
                          child: Text(
                            '${widget.currentQuestion}',
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              color: Color(0xFF61450F),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Icons.local_fire_department,
            color: Color(0xFFFFA726),
            size: 22,
          ),
          const SizedBox(width: 4),
          Text(
            '${widget.streak}',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
              color: Color(0xFF61450F),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
