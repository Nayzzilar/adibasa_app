// lib/widgets/gamification/card_level_complete.dart
import 'package:adibasa_app/widgets/info_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/lesson_game_provider.dart'; // Ganti import provider

class CardLevelComplete extends ConsumerStatefulWidget {
  final Duration duration;
  final int correctPercentage;

  const CardLevelComplete({
    Key? key,
    required this.duration,
    required this.correctPercentage,
  }) : super(key: key);

  @override
  ConsumerState<CardLevelComplete> createState() => _CardLevelCompleteState();
}

class _CardLevelCompleteState extends ConsumerState<CardLevelComplete>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _scoreAnimation;
  late Animation<double> _durationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scoreAnimation = IntTween(
      begin: 0,
      end: widget.correctPercentage,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _durationAnimation = Tween<double>(
      begin: 0,
      end: widget.duration.inSeconds.toDouble(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final gameState = ref.read(lessonGameProvider);

    return Container(
      width: screenWidth * 1.3,
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.1,
        vertical: screenHeight * 0.0008,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline, // Warna border
          width: 4, // Ketebalan border
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.004,
              horizontal: screenWidth * 0.004,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Text(
              'Level ${gameState.currentLesson?.order ?? ""} Telah Diselesaikan!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Content
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Waktu Section
                  Expanded(
                    child: _buildInfoColumn(
                      context,
                      Icons.access_time,
                      'Waktu',
                      formatDuration(
                        Duration(seconds: _durationAnimation.value.toInt()),
                      ),
                    ),
                  ),
                  // Score Section
                  Expanded(
                    child: _buildInfoColumn(
                      context,
                      Icons.check,
                      'Score',
                      '${_scoreAnimation.value}%',
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          // Icon dan Title dalam Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.015),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          // Value di bawah
          InfoBadge(value: value, fontSize: 16),
        ],
      ),
    );
  }
}
