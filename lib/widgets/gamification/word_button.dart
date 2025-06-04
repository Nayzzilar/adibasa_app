// widgets/gamification/word_button.dart
import 'package:flutter/material.dart';
import 'package:adibasa_app/theme/theme.dart';

class WordButton extends StatelessWidget {
  final String word;
  final bool isSelected;
  final bool isAnswered;
  final int? orderNumber;
  final VoidCallback? onTap;

  const WordButton({
    super.key,
    required this.word,
    required this.isSelected,
    required this.isAnswered,
    this.orderNumber,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final feedbackColors = theme.extension<FeedbackColors>();

    if (feedbackColors == null) {
      throw Exception('FeedbackColors extension not found in theme');
    }

    // Determine colors based on state
    Color backgroundColor;
    Color borderColor;
    Color textColor;

    if (isSelected) {
      backgroundColor = colorScheme.tertiaryContainer;
      borderColor = colorScheme.tertiary;
      textColor = colorScheme.onPrimary;
    } else {
      backgroundColor = colorScheme.surface;
      borderColor = colorScheme.outline;
      textColor = colorScheme.onSurface;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        elevation: isSelected ? 3 : 1,
        child: InkWell(
          onTap: isAnswered ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: borderColor, width: 1),
                left: BorderSide(color: borderColor, width: 1),
                right: BorderSide(color: borderColor, width: 1),
                bottom: BorderSide(color: borderColor, width: 3),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  word,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
