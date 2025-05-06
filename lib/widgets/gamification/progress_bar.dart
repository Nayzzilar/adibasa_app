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

class _ProgressBarState extends State<ProgressBar> with TickerProviderStateMixin {
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
    _sparkleAnim = CurvedAnimation(parent: _sparkleController, curve: Curves.easeOut);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _pulseAnim = CurvedAnimation(parent: _pulseController, curve: Curves.easeOut);
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
    final textTheme = Theme.of(context).textTheme;
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
                double min = 0;
                double max = barWidth;
                double pos = min + (max - min) * ((widget.currentQuestion - 1) / (widget.totalQuestions - 1).clamp(1, double.infinity));
                pos = pos.clamp(min, max - 38);
                double progress = widget.currentQuestion / widget.totalQuestions;
                return SizedBox(
                  height: 36,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // Background bar
                      Positioned(
                        top: 9,
                        child: Container(
                          width: barWidth,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0CDAA).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      // Progress bar dengan warna solid hijau untuk selesai
                      Positioned(
                        top: 9,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                          width: barWidth * progress,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF5E661F), // hijau selesai
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      // Bar belum selesai warna coklat
                      Positioned(
                        top: 9,
                        left: barWidth * progress,
                        child: Container(
                          width: barWidth * (1 - progress),
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B4711), // coklat belum selesai
                            borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
                          ),
                        ),
                      ),
                      // Lingkaran nomor soal mengikuti progress
                      Positioned(
                        left: pos,
                        top: 0,
                        child: AnimatedBuilder(
                          animation: _pulseAnim,
                          builder: (context, child) {
                            final scale = 1 + 0.18 * (1 - (_pulseAnim.value - 0.5).abs() * 2);
                            return Transform.scale(
                              scale: scale,
                              child: child,
                            );
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF61450F), width: 2.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.10),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
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
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: AnimatedScale(
                  scale: 1 + 0.4 * _sparkleAnim.value,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  child: Icon(Icons.local_fire_department, color: Color(0xFFFFA726), size: 22),
                ),
              ),
              SizedBox(
                width: 32,
                height: 32,
                child: AnimatedBuilder(
                  animation: _sparkleAnim,
                  builder: (context, child) {
                    if (_sparkleAnim.value == 0) return const SizedBox.shrink();
                    final sparkleCount = 6;
                    final sparkleRadius = 14.0 + 6 * _sparkleAnim.value;
                    final sparkleOpacity = 1.0 - _sparkleAnim.value;
                    return Stack(
                      children: List.generate(sparkleCount, (i) {
                        final angle = 2 * pi * i / sparkleCount;
                        return Positioned(
                          left: 16 + sparkleRadius * cos(angle),
                          top: 16 + sparkleRadius * sin(angle),
                          child: Opacity(
                            opacity: sparkleOpacity,
                            child: Text(
                              '✨',
                              style: TextStyle(fontSize: 10 + 4 * (1 - _sparkleAnim.value)),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
          Text('${widget.streak}', style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, color: Color(0xFF61450F), fontSize: 18)),
        ],
      ),
    );
  }
} 