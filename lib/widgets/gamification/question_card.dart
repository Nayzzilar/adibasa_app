import 'package:adibasa_app/models/challenge_option_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

typedef NewWordTapCallback = void Function(GlobalKey key);

class QuestionCard extends StatefulWidget {
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
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  late List<bool> _optionVisible;

  @override
  void initState() {
    super.initState();
    _startStaggeredAnim();
  }

  @override
  void didUpdateWidget(covariant QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      _startStaggeredAnim();
    }
  }

  void _startStaggeredAnim() {
    _optionVisible = List.generate(widget.options.length, (i) => false);
    for (int i = 0; i < widget.options.length; i++) {
      Future.delayed(Duration(milliseconds: 80 * i), () {
        if (mounted && i < _optionVisible.length) {
          setState(() {
            _optionVisible[i] = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final GlobalKey wordKey = GlobalKey();
    return GestureDetector(
      onTap: widget.onNewWordBubbleClose,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.isNewWord
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Builder(
                      builder: (context) {
                        final match = RegExp(
                          r'"([^"]+)"',
                        ).firstMatch(widget.question);
                        final word = match != null ? match.group(1) ?? '' : '';
                        final before = widget.question.split('"')[0];
                        final after =
                            widget.question.split('"').length > 2
                                ? widget.question.split('"')[2]
                                : '';
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(before, style: textTheme.titleMedium),
                            GestureDetector(
                              key: wordKey,
                              onTap: () => widget.onNewWordTap?.call(wordKey),
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
                  widget.question,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
            const SizedBox(height: 16),
            ...List.generate(widget.options.length, (index) {
              final isSelected = widget.selectedIndex == index;
              final isCorrect = widget.correctIndex == index;
              Color borderColor;
              Color? tileColor;
              if (widget.isAnswered) {
                if (isCorrect) {
                  borderColor = const Color(0xFF2E7D32); // hijau
                  tileColor = const Color(0xFFE6F4EA); // hijau muda
                } else if (isSelected) {
                  borderColor = const Color(0xFFD32F2F); // merah
                  tileColor = const Color(0xFFFFE6E6); // merah muda
                } else {
                  borderColor = const Color(0xFFE0CDAA); // soft outline
                  tileColor = const Color(0xFFF8F5F0); // soft bg
                }
              } else {
                borderColor =
                    isSelected
                        ? const Color(0xFF61450F)
                        : const Color(0xFFE0CDAA);
                tileColor =
                    isSelected
                        ? const Color(0xFFF1DFBE)
                        : const Color(0xFFF8F5F0);
              }
              return AnimatedOpacity(
                opacity: _optionVisible[index] ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: AnimatedScale(
                  scale: _optionVisible[index] ? 1 : 0.95,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Material(
                      color: tileColor,
                      borderRadius: BorderRadius.circular(18),
                      elevation: isSelected && !widget.isAnswered ? 1 : 0,
                      shadowColor: Colors.black.withOpacity(0.04),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap:
                            widget.isAnswered
                                ? null
                                : () => widget.onOptionSelected(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 18,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor, width: 2),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              // Custom radio circle
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        widget.isAnswered
                                            ? (isCorrect
                                                ? const Color(0xFF2E7D32)
                                                : (isSelected
                                                    ? const Color(0xFFD32F2F)
                                                    : const Color(0xFFE0CDAA)))
                                            : (isSelected
                                                ? const Color(0xFF61450F)
                                                : const Color(0xFFE0CDAA)),
                                    width: 2.2,
                                  ),
                                  color:
                                      widget.isAnswered
                                          ? (isCorrect
                                              ? const Color(0xFFE6F4EA)
                                              : (isSelected
                                                  ? const Color(0xFFFFE6E6)
                                                  : Colors.transparent))
                                          : (isSelected
                                              ? const Color(0xFFF1DFBE)
                                              : Colors.transparent),
                                ),
                                child: Center(
                                  child:
                                      isSelected
                                          ? Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  widget.isAnswered
                                                      ? (isCorrect
                                                          ? const Color(
                                                            0xFF2E7D32,
                                                          )
                                                          : (isSelected
                                                              ? const Color(
                                                                0xFFD32F2F,
                                                              )
                                                              : Colors
                                                                  .transparent))
                                                      : const Color(0xFF61450F),
                                            ),
                                          )
                                          : null,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  widget.options[index],
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    color:
                                        widget.isAnswered
                                            ? (isCorrect
                                                ? const Color(0xFF2E7D32)
                                                : (isSelected
                                                    ? const Color(0xFFD32F2F)
                                                    : const Color(0xFF61450F)))
                                            : const Color(0xFF61450F),
                                    fontWeight:
                                        isSelected || isCorrect
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
