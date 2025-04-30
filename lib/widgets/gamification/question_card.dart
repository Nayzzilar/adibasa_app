import 'package:adibasa_app/models/challenge_option_model.dart';
import 'package:flutter/material.dart';

typedef NewWordTapCallback = void Function(GlobalKey key);

class QuestionCard extends StatelessWidget {
  final String question;
  final List<ChallengeOption> options;
  final int? selectedIndex;
  final ValueChanged<int> onOptionSelected;
  final bool isAnswered;
  final int? correctIndex;
  final bool isNewWord;
  final NewWordTapCallback? onNewWordTap;
  final VoidCallback? onNewWordBubbleClose;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.options,
    required this.selectedIndex,
    required this.onOptionSelected,
    required this.isAnswered,
    required this.correctIndex,
    this.isNewWord = false,
    this.onNewWordTap,
    this.onNewWordBubbleClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final GlobalKey wordKey = GlobalKey();
    return GestureDetector(
      onTap: onNewWordBubbleClose,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isNewWord
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Builder(
                      builder: (context) {
                        final match = RegExp(r'"([^"]+)"').firstMatch(question);
                        final word = match != null ? match.group(1) ?? '' : '';
                        final before = question.split('"')[0];
                        final after =
                            question.split('"').length > 2
                                ? question.split('"')[2]
                                : '';
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(before, style: textTheme.titleMedium),
                            GestureDetector(
                              key: wordKey,
                              onTap: () => onNewWordTap?.call(wordKey),
                              child: Text(
                                word,
                                style: textTheme.titleMedium?.copyWith(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Text(after, style: textTheme.titleMedium),
                          ],
                        );
                      },
                    ),
                  ],
                )
                : Text(
                  question,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
            const SizedBox(height: 16),
            ...List.generate(options.length, (index) {
              final isSelected = selectedIndex == index;
              final isCorrect = correctIndex == index;
              Color borderColor;
              Color? tileColor;
              if (isAnswered) {
                if (isCorrect) {
                  borderColor = colorScheme.primary;
                  tileColor = colorScheme.primaryFixed.withOpacity(0.2);
                } else if (isSelected) {
                  borderColor = colorScheme.error;
                  tileColor = colorScheme.errorContainer.withOpacity(0.2);
                } else {
                  borderColor = colorScheme.outlineVariant;
                  tileColor = colorScheme.surface;
                }
              } else {
                borderColor =
                    isSelected
                        ? colorScheme.primary
                        : colorScheme.outlineVariant;
                tileColor =
                    isSelected
                        ? colorScheme.primaryFixed.withOpacity(0.1)
                        : colorScheme.surface;
              }
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: isAnswered ? null : () => onOptionSelected(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor, width: 2),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow:
                            isSelected && !isAnswered
                                ? [
                                  BoxShadow(
                                    color: colorScheme.primary.withOpacity(
                                      0.08,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                                : [],
                      ),
                      child: Row(
                        children: [
                          Radio<int>(
                            value: index,
                            groupValue: selectedIndex,
                            onChanged:
                                isAnswered
                                    ? null
                                    : (val) => onOptionSelected(index),
                            activeColor: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              options[index].text,
                              style: textTheme.bodyLarge?.copyWith(
                                color:
                                    isAnswered
                                        ? (isCorrect
                                            ? colorScheme.primary
                                            : (isSelected
                                                ? colorScheme.error
                                                : colorScheme.onSurfaceVariant))
                                        : colorScheme.onSurface,
                                fontWeight:
                                    isSelected || isCorrect
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
