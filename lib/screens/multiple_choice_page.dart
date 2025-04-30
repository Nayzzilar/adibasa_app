import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adibasa_app/models/lesson_model.dart';
import 'package:adibasa_app/models/challenge_model.dart';
import 'package:adibasa_app/widgets/gamification/question_card.dart';
import 'package:adibasa_app/widgets/gamification/progress_bar.dart';
import 'package:adibasa_app/widgets/gamification/result_dialog.dart';
import 'package:adibasa_app/widgets/gamification/exit_dialog.dart';
import 'package:adibasa_app/widgets/gamification/new_word_popup.dart';
import 'package:adibasa_app/providers/duration_provider.dart';
import 'package:adibasa_app/providers/star_provider.dart';
import 'package:adibasa_app/providers/streak_provider.dart';

class MultipleChoicePage extends ConsumerStatefulWidget {
  final Lesson lesson;

  const MultipleChoicePage({super.key, required this.lesson});

  @override
  ConsumerState<MultipleChoicePage> createState() => _MultipleChoicePageState();
}

class _MultipleChoicePageState extends ConsumerState<MultipleChoicePage> {
  int _currentIndex = 0;
  int? _selectedIndex;
  bool _isAnswered = false;
  int? _correctIndex;
  bool _showResult = false;
  bool _isCorrect = false;
  DateTime? _levelStartTime;
  OverlayEntry? _popupEntry;
  String _newWord = '';
  String _newWordMeaning = '';

  @override
  void initState() {
    super.initState();
    _levelStartTime = DateTime.now();
  }

  List<Challenge> get challenges => widget.lesson.challenges ?? [];

  void _onOptionSelected(int index) {
    if (_isAnswered || challenges.isEmpty) return;

    final currentChallenge = challenges[_currentIndex];
    final correctIndex =
        currentChallenge.options?.indexWhere((o) => o.correct) ?? -1;

    setState(() {
      _selectedIndex = index;
      _isAnswered = true;
      _correctIndex = correctIndex;
      _isCorrect = index == correctIndex;
      _showResult = true;
    });

    final streakNotifier = ref.read(streakProvider.notifier);
    _isCorrect ? streakNotifier.increment() : streakNotifier.reset();
  }

  void _onContinue() {
    _hideNewWordBubble();
    if (_currentIndex < challenges.length - 1) {
      setState(() {
        _resetQuestionState();
        _currentIndex++;
      });
    } else {
      _handleLevelCompletion();
    }
  }

  void _resetQuestionState() {
    _showResult = false;
    _isAnswered = false;
    _selectedIndex = null;
    _correctIndex = null;
  }

  void _handleLevelCompletion() {
    final duration = DateTime.now().difference(_levelStartTime!);
    ref.read(durationProvider.notifier).setDuration(duration);
    ref.read(starProvider.notifier).calculateStar(duration);
    Navigator.pushReplacementNamed(context, '/level-complete');
  }

  void _showNewWordBubble(GlobalKey key, String word, String meaning) {
    if (_popupEntry != null && _newWord == word) {
      _hideNewWordBubble();
      return;
    }

    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final offset = renderBox?.localToGlobal(Offset.zero) ?? Offset(100, 100);

    _popupEntry = OverlayEntry(
      builder:
          (context) => NewWordPopup(
            word: word,
            meaning: meaning,
            position: Offset(
              offset.dx + renderBox!.size.width + 8,
              offset.dy - 8,
            ),
          ),
    );

    Overlay.of(context).insert(_popupEntry!);
  }

  void _hideNewWordBubble() {
    _popupEntry?.remove();
    _popupEntry = null;
  }

  void _showExitDialogOverlay() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
      builder:
          (context) => ExitDialog(
            onContinue: () => Navigator.pop(context),
            onExit: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (challenges.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            'No challenges available',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      );
    }

    final currentChallenge = challenges[_currentIndex];
    final isNewWord = true;
    final streak = ref.watch(streakProvider);

    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          ProgressBar(
            currentQuestion: _currentIndex + 1,
            totalQuestions: challenges.length,
            streak: streak,
            onClose: _showExitDialogOverlay,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isNewWord)
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8, bottom: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/image/KataBaru.png',
                          width: 18,
                          height: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Kata Baru',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: QuestionCard(
                    question: currentChallenge.question,
                    options: currentChallenge.options!,
                    selectedIndex: _selectedIndex,
                    onOptionSelected:
                        (index) => setState(() => _selectedIndex = index),
                    isAnswered: _isAnswered,
                    correctIndex: _correctIndex,
                    onNewWordTap:
                        isNewWord
                            ? (key) {
                              final match = RegExp(
                                r'"([^"]+)"',
                              ).firstMatch(currentChallenge.question);
                              final word = match?.group(1) ?? '';
                              final meaning =
                                  currentChallenge.options
                                      ?.firstWhere((o) => o.correct)
                                      .text ??
                                  '';
                              _showNewWordBubble(key, word, meaning);
                            }
                            : null,
                    onNewWordBubbleClose: _hideNewWordBubble,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child:
                  _showResult
                      ? const SizedBox.shrink()
                      : _isAnswered
                      ? ElevatedButton(
                        onPressed: _onContinue,
                        child: const Text('Lanjutkan'),
                      )
                      : ElevatedButton(
                        onPressed:
                            _selectedIndex != null
                                ? () => _onOptionSelected(_selectedIndex!)
                                : null,
                        child: const Text('Periksa'),
                      ),
            ),
          ),
        ],
      ),
      bottomSheet:
          _showResult
              ? ResultDialog(
                isCorrect: _isCorrect,
                correctAnswer:
                    currentChallenge.options
                        ?.elementAt(_correctIndex ?? 0)
                        .text ??
                    '',
                onContinue: _onContinue,
              )
              : null,
    );
  }
}
