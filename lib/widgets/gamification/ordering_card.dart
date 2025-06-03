// widgets/gamification/ordering_card.dart
import 'package:flutter/material.dart';
import 'package:adibasa_app/models/challenge_option_model.dart';
import 'package:adibasa_app/widgets/gamification/new_word_text.dart';
import 'package:adibasa_app/theme/theme.dart';
import 'word_button.dart';

class OrderingCard extends StatefulWidget {
  final String question;
  final List<ChallengeOption> options;
  final List<int> selectedWordIndices; // CHANGED: Use indices
  final ValueChanged<List<int>> onWordIndicesChanged; // CHANGED: Use indices
  final bool isAnswered;
  final bool isCorrect;
  final bool isNewWord;
  final VoidCallback? onNewWordBubbleClose;

  const OrderingCard({
    super.key,
    required this.question,
    required this.options,
    required this.selectedWordIndices,
    required this.onWordIndicesChanged,
    required this.isAnswered,
    required this.isCorrect,
    required this.isNewWord,
    this.onNewWordBubbleClose,
  });

  @override
  State<OrderingCard> createState() => _OrderingCardState();
}

class _OrderingCardState extends State<OrderingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _wordAnimations;
  List<String> _availableWords = [];
  List<int> _shuffledIndices = []; // CHANGED: Use indices instead of words

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _setupWords();
    _setupAnimations();
    _animationController.forward();
  }

  void _setupWords() {
    final correctOption = widget.options.firstWhere((o) => o.correct);
    _availableWords =
        correctOption.text.split(' ').where((word) => word.isNotEmpty).toList();

    // Create indices for each word position
    _shuffledIndices = List.generate(_availableWords.length, (index) => index);
    if (!widget.isAnswered) {
      _shuffledIndices.shuffle();
    }
  }

  void _setupAnimations() {
    _wordAnimations =
        _shuffledIndices.map((wordIndex) {
          final animationIndex = _shuffledIndices.indexOf(wordIndex);
          return Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(animationIndex * 0.1, 1.0, curve: Curves.easeOut),
            ),
          );
        }).toList();
  }

  @override
  void didUpdateWidget(covariant OrderingCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      _setupWords();
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

  void _onWordTap(int wordIndex) {
    if (widget.isAnswered) return;

    List<int> newSelectedIndices = List.from(widget.selectedWordIndices);

    if (newSelectedIndices.contains(wordIndex)) {
      newSelectedIndices.remove(wordIndex);
    } else {
      newSelectedIndices.add(wordIndex);
    }

    widget.onWordIndicesChanged(newSelectedIndices);
  }

  void _onSelectedWordTap(int wordIndex) {
    if (widget.isAnswered) return;

    List<int> newSelectedIndices = List.from(widget.selectedWordIndices);
    newSelectedIndices.remove(wordIndex);
    widget.onWordIndicesChanged(newSelectedIndices);
  }

  // Calculate the height needed for the word areas
  double _calculateWordsAreaHeight(BuildContext context) {
    // Estimate button height (you may need to adjust based on your WordButton)
    const double buttonHeight = 48.0;
    const double runSpacing = 12.0;
    const double containerPadding = 32.0; // 16 top + 16 bottom

    // Get screen width and calculate available width for buttons
    final screenWidth = MediaQuery.of(context).size.width;
    const double horizontalPadding =
        40.0; // 20 left + 20 right from main padding
    const double wordSpacing = 8.0;
    final availableWidth = screenWidth - horizontalPadding - containerPadding;

    // Estimate average word width (you may need to adjust this)
    const double averageWordWidth = 80.0;
    final wordsPerRow = (availableWidth / (averageWordWidth + wordSpacing))
        .floor()
        .clamp(1, 10);

    // Calculate number of rows needed
    final totalRows = (_availableWords.length / wordsPerRow).ceil();

    // Calculate total height
    final totalHeight =
        (totalRows * buttonHeight) +
        ((totalRows - 1) * runSpacing) +
        containerPadding;

    return totalHeight;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onNewWordBubbleClose,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildQuestionText(context),
            const SizedBox(height: 24),
            _buildSelectedWordsArea(context),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: _buildAvailableWords(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionText(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final defaultStyle = textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primaryContainer,
    );

    if (!widget.isNewWord) {
      return Text(widget.question, style: defaultStyle);
    }

    return NewWordText(
      question: widget.question,
      correctMeaning: widget.options.first.text,
      textStyle: textTheme.titleLarge,
    );
  }

  Widget _buildSelectedWordsArea(BuildContext context) {
    final theme = Theme.of(context);
    final feedbackColors = theme.extension<FeedbackColors>();

    if (feedbackColors == null) {
      throw Exception('FeedbackColors extension not found in theme');
    }

    Color backgroundColor = theme.colorScheme.surface;
    Color borderColor = theme.colorScheme.outline;

    if (widget.isAnswered) {
      if (widget.isCorrect) {
        backgroundColor = feedbackColors.correctBackground;
        borderColor = feedbackColors.correctForeground;
      } else {
        backgroundColor = feedbackColors.wrongBackground;
        borderColor = feedbackColors.wrongForeground;
      }
    }

    final areaHeight = _calculateWordsAreaHeight(context);

    return Container(
      width: double.infinity,
      height: areaHeight + 3,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: widget.isAnswered ? 2 : 1,
        ),
      ),
      child:
          widget.selectedWordIndices.isEmpty
              ? Center(
                child: Text(
                  'Tap kata dengan urutan yang benar!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
              : SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 12,
                  children:
                      widget.selectedWordIndices.asMap().entries.map((entry) {
                        final orderIndex = entry.key;
                        final wordIndex = entry.value;
                        final word = _availableWords[wordIndex];
                        return Container(
                          child: WordButton(
                            word: word,
                            isSelected: true,
                            isAnswered: widget.isAnswered,
                            orderNumber: orderIndex + 1,
                            onTap: () => _onSelectedWordTap(wordIndex),
                          ),
                        );
                      }).toList(),
                ),
              ),
    );
  }

  Widget _buildAvailableWords(BuildContext context) {
    final availableIndices =
        _shuffledIndices
            .where(
              (wordIndex) => !widget.selectedWordIndices.contains(wordIndex),
            )
            .toList();

    return Container(
      height: _calculateWordsAreaHeight(context),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 8,
          runSpacing: 12,
          children:
              availableIndices.map((wordIndex) {
                final animationIndex = _shuffledIndices.indexOf(wordIndex);
                final word = _availableWords[wordIndex];

                return AnimatedBuilder(
                  animation: _wordAnimations[animationIndex],
                  builder: (context, child) {
                    return Opacity(
                      opacity: _wordAnimations[animationIndex].value,
                      child: Transform.translate(
                        offset: Offset(
                          0,
                          20 * (1 - _wordAnimations[animationIndex].value),
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: WordButton(
                    word: word,
                    isSelected: false,
                    isAnswered: widget.isAnswered,
                    onTap: () => _onWordTap(wordIndex),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
