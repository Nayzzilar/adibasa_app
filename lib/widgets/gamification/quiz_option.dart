import 'package:adibasa_app/models/challenge_option_model.dart';
import 'package:adibasa_app/theme/theme.dart';
import 'package:flutter/material.dart';

class QuizOption extends StatelessWidget {
  final ChallengeOption option;
  final bool isSelected;
  final bool isAnswered;
  final bool isCorrect;
  final VoidCallback? onTap;

  const QuizOption({
    super.key,
    required this.option,
    required this.isSelected,
    required this.isAnswered,
    required this.isCorrect,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final optionTheme = _getOptionTheme(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Material(
        color: optionTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        elevation: isSelected && !isAnswered ? 1 : 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: optionTheme.indicatorBorderColor,
                  width: 1,
                ),
                left: BorderSide(
                  color: optionTheme.indicatorBorderColor,
                  width: 1,
                ),
                right: BorderSide(
                  color: optionTheme.indicatorBorderColor,
                  width: 1,
                ),
                bottom: BorderSide(
                  color: optionTheme.indicatorBorderColor,
                  width: 3,
                ),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildRadioIndicator(optionTheme),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    option.text,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: optionTheme.textColor,
                      fontWeight:
                          isSelected || isCorrect
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioIndicator(OptionTheme optionTheme) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: optionTheme.indicatorBorderColor, width: 2.2),
        color: optionTheme.indicatorBackgroundColor,
      ),
      child:
          isSelected
              ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: optionTheme.indicatorDotColor,
                  ),
                ),
              )
              : null,
    );
  }

  OptionTheme _getOptionTheme(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final feedbackColors = Theme.of(context).extension<FeedbackColors>();

    if (feedbackColors == null) {
      throw Exception('FeedbackColors extension not found in theme');
    }

    if (isAnswered) {
      if (isCorrect) {
        return OptionTheme(
          backgroundColor: feedbackColors.correctBackground,
          borderColor: feedbackColors.correctForeground,
          textColor: colorScheme.onSurface,
          indicatorBorderColor: feedbackColors.correctForeground,
          indicatorBackgroundColor: feedbackColors.correctBackground,
          indicatorDotColor: feedbackColors.correctForeground,
        );
      }
      if (isSelected) {
        return OptionTheme(
          backgroundColor: feedbackColors.wrongBackground,
          borderColor: feedbackColors.wrongForeground,
          textColor: colorScheme.onSurface,
          indicatorBorderColor: feedbackColors.wrongForeground,
          indicatorBackgroundColor: feedbackColors.wrongBackground,
          indicatorDotColor: feedbackColors.wrongForeground,
        );
      }
    }

    return OptionTheme(
      backgroundColor:
          isSelected ? colorScheme.secondaryContainer : colorScheme.surface,
      borderColor:
          isSelected ? colorScheme.primaryContainer : colorScheme.outline,
      textColor: colorScheme.primaryContainer,
      indicatorBorderColor:
          isSelected ? colorScheme.tertiaryContainer : colorScheme.outline,
      indicatorBackgroundColor:
          isSelected ? colorScheme.secondaryContainer : colorScheme.surface,
      indicatorDotColor: colorScheme.tertiaryContainer,
    );
  }
}

@immutable
class OptionTheme {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color indicatorBorderColor;
  final Color indicatorBackgroundColor;
  final Color indicatorDotColor;

  const OptionTheme({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.indicatorBorderColor,
    required this.indicatorBackgroundColor,
    required this.indicatorDotColor,
  });
}
