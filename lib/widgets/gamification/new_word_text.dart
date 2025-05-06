import 'package:flutter/material.dart';

class NewWordText extends StatelessWidget {
  final String question;
  final String correctMeaning;
  final TextStyle? textStyle;

  const NewWordText({
    super.key,
    required this.question,
    required this.correctMeaning,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (!question.contains('_')) {
      return _UnderlinedWord(
        text: question,
        meaning: correctMeaning,
        style: textStyle,
      );
    }

    final textParts = question.split('_');

    return RichText(
      text: TextSpan(
        style: textStyle?.copyWith(color: Colors.black),
        children: _buildTextSpans(textParts),
      ),
    );
  }

  List<InlineSpan> _buildTextSpans(List<String> parts) {
    final spans = <InlineSpan>[];
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isEmpty) continue;

      spans.add(
        i.isOdd
            ? WidgetSpan(
              child: _UnderlinedWord(
                text: parts[i],
                meaning: correctMeaning,
                style: textStyle,
              ),
            )
            : TextSpan(text: parts[i]),
      );
    }
    return spans;
  }
}

class _UnderlinedWord extends StatelessWidget {
  final String text;
  final String meaning;
  final TextStyle? style;

  const _UnderlinedWord({
    required this.text,
    required this.meaning,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textStyle = theme.textTheme;
    final defaultStyle = textStyle.bodyLarge ?? const TextStyle();

    return Tooltip(
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(days: 1),
      padding: const EdgeInsets.all(12),
      preferBelow: true,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline, width: 2),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(50),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      message: meaning,
      textStyle: defaultStyle.copyWith(
        color: colorScheme.tertiary,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      child: Text(
        text,
        style: textStyle.titleLarge!.copyWith(
          color: colorScheme.tertiary,
          decoration: TextDecoration.underline,
          decorationColor: colorScheme.tertiary,
        ),
      ),
    );
  }
}
