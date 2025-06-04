import 'package:adibasa_app/widgets/gamification/new_word_text.dart';
import 'package:flutter/material.dart';
import 'package:adibasa_app/models/challenge_option_model.dart';

import 'quiz_option.dart';

class QuestionCard extends StatefulWidget {
  final String question;
  final List<ChallengeOption> options;
  final int? selectedIndex;
  final ValueChanged<int> onOptionSelected;
  final bool isAnswered;
  final int? correctIndex;
  final bool isNewWord;
  final VoidCallback? onNewWordBubbleClose;

  const QuestionCard({
    super.key,
    required this.question,
    required this.options,
    required this.selectedIndex,
    required this.onOptionSelected,
    required this.isAnswered,
    required this.correctIndex,
    required this.isNewWord,
    this.onNewWordBubbleClose,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _optionAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _setupAnimations();
    _animationController.forward();
  }

  void _setupAnimations() {
    _optionAnimations =
        widget.options.asMap().entries.map((entry) {
          final index = entry.key;
          return Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(index * 0.15, 1.0, curve: Curves.easeOut),
            ),
          );
        }).toList();
  }

  @override
  void didUpdateWidget(covariant QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      _animationController.reset();
      _setupAnimations();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: widget.onNewWordBubbleClose,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildQuestionText(context, textTheme),
            const SizedBox(height: 16),
            ...widget.options.asMap().entries.map((entry) {
              final index = entry.key;
              return _buildOptionItem(
                entry.value,
                index,
                colorScheme,
                textTheme,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionText(BuildContext context, TextTheme textTheme) {
    // Base style for question text when it's not a "new word" (isNewWord == false)
    final defaultStyleForNonNewWord = textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primaryContainer,
    );

    // Style for text that should be underlined when isNewWord == false
    final underlinedStyleForNonNewWord = defaultStyleForNonNewWord?.copyWith(
      decoration: TextDecoration.underline,
      decorationColor:
          defaultStyleForNonNewWord
              .color, // Match underline color to text color
    );

    if (!widget.isNewWord) {
      if (widget.question.contains('_')) {
        final textParts = widget.question.split('_');
        List<InlineSpan> spans = [];

        for (int i = 0; i < textParts.length; i++) {
          if (textParts[i].isEmpty) {
            continue;
          }

          spans.add(
            TextSpan(
              text: textParts[i],
              style:
                  i.isOdd
                      ? underlinedStyleForNonNewWord
                      : defaultStyleForNonNewWord,
            ),
          );
        }

        return RichText(
          text: TextSpan(style: defaultStyleForNonNewWord, children: spans),
        );
      } else {
        return Text(widget.question, style: defaultStyleForNonNewWord);
      }
    }

    return NewWordText(
      question: widget.question,
      correctMeaning: widget.options.firstWhere((o) => o.correct).text,
      textStyle: textTheme.titleLarge,
    );
  }

  Widget _buildOptionItem(
    ChallengeOption option,
    int index,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final isSelected = widget.selectedIndex == index;
    final isCorrect = widget.correctIndex == index;

    return AnimatedBuilder(
      animation: _optionAnimations[index],
      builder: (context, child) {
        return Opacity(
          opacity: _optionAnimations[index].value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _optionAnimations[index].value)),
            child: child,
          ),
        );
      },
      child: QuizOption(
        option: option,
        isSelected: isSelected,
        isAnswered: widget.isAnswered,
        isCorrect: isCorrect,
        onTap: widget.isAnswered ? null : () => widget.onOptionSelected(index),
      ),
    );
  }
}
