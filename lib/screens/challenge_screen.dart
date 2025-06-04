// screens/multiple_choice_page.dart
import 'package:adibasa_app/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/lesson_model.dart';
import '../models/challenge_model.dart';
import '../providers/lesson_game_provider.dart';
import '../widgets/gamification/progress_bar.dart';
import '../widgets/gamification/question_card.dart';
import '../widgets/gamification/ordering_card.dart';
import '../widgets/gamification/result_dialog.dart';
import '../widgets/gamification/exit_dialog.dart';

class ChallengeScreen extends ConsumerStatefulWidget {
  const ChallengeScreen({super.key});

  @override
  ConsumerState<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends ConsumerState<ChallengeScreen> {
  int _currentIndex = 0;

  // Multiple choice state
  int? _selectedIndex;

  // Ordering state
  List<int> _selectedWordIndices = [];

  // Common state
  int? _correctIndex;
  bool _isAnswered = false;
  bool _showResult = false;
  bool _isCorrect = false;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    Future.microtask(() {
      ref.read(lessonGameProvider.notifier).startTimer();
      setState(() {});
    });
  }

  Lesson? get _currentLesson => ref.read(lessonGameProvider).currentLesson;
  List<Challenge> get challenges => _currentLesson?.challenges ?? [];
  Challenge get currentChallenge => challenges[_currentIndex];

  void _onOptionSelected(int index) {
    if (_isAnswered) return;
    setState(() => _selectedIndex = index);
  }

  void _onWordIndicesChanged(List<int> indices) {
    if (_isAnswered) return;
    setState(() => _selectedWordIndices = indices);
  }

  bool get _canContinue {
    if (currentChallenge.challengeType == ChallengeType.multipleChoice) {
      return _selectedIndex != null;
    } else {
      return _selectedWordIndices.length > 0;
    }
  }

  bool _checkAnswer() {
    if (currentChallenge.challengeType == ChallengeType.multipleChoice) {
      _correctIndex =
          currentChallenge.options?.indexWhere((o) => o.correct) ?? -1;
      return _selectedIndex == _correctIndex;
    } else {
      // Check if the selected word indices match the correct sentence
      final correctOption = currentChallenge.options!.firstWhere(
        (o) => o.correct,
      );
      final correctWords =
          correctOption.text.split(' ').where((w) => w.isNotEmpty).toList();

      // Convert selected indices back to words and join
      final selectedWords =
          _selectedWordIndices.map((index) => correctWords[index]).toList();
      final userSentence = selectedWords.join(' ');
      final correctSentence = correctOption.text;

      return userSentence == correctSentence;
    }
  }

  Future<void> _onContinue() async {
    final userDataNotifier = ref.read(userDataProvider.notifier);

    final lessonGameNotifier = ref.read(lessonGameProvider.notifier);
    if (!_isAnswered) {
      setState(() {
        _isAnswered = true;
        _isCorrect = _checkAnswer();
        _showResult = true;
      });

      lessonGameNotifier.recordChallengeResult(_isCorrect);
      if (_isCorrect) {
        userDataNotifier.incrementStreak();
      } else {
        _currentLesson!.challenges?.add(currentChallenge);
        userDataNotifier.resetStreak();
      }

      try {
        await _audioPlayer.stop();
        await _audioPlayer.play(
          AssetSource(_isCorrect ? 'audio/benar.mp3' : 'audio/salah.mp3'),
        );
      } catch (e) {
        debugPrint('Audio error: $e');
      }

      return;
    } else {
      if (_isCorrect) {
        print("wot to len ${currentChallenge.wordToLearn}");
        if (currentChallenge.wordToLearn != null &&
            currentChallenge.wordToLearn!.isNotEmpty) {
          print("wot to len ${currentChallenge.wordToLearn}");
          userDataNotifier.addSeenWord(currentChallenge.wordToLearn!);
        }
      }
    }

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
    _selectedWordIndices = [];
    _correctIndex = null;
  }

  void _handleLevelCompletion() {
    Future.microtask(() {
      final lessonGameNotifier = ref.read(lessonGameProvider.notifier);
      lessonGameNotifier.calculateStars();
      lessonGameNotifier.saveCompletionWithBestScore();
      Navigator.pushReplacementNamed(context, '/level_complete');
    });
  }

  void _showExitDialogOverlay() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => ExitDialog(
            onContinue: () => Navigator.pop(context),
            onExit: () {
              ref.read(lessonGameProvider.notifier).stopTimer();
              ref.read(userDataProvider.notifier).resetStreak();
              Navigator.pushReplacementNamed(context, '/bottom_navbar');
            },
          ),
    );
  }

  String get _correctAnswerText {
    if (currentChallenge.challengeType == ChallengeType.multipleChoice) {
      return _correctIndex != null &&
              _correctIndex! < currentChallenge.options!.length
          ? currentChallenge.options![_correctIndex!].text
          : '';
    } else {
      // For ordering, show the correct sentence
      return currentChallenge.options!.firstWhere((o) => o.correct).text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;

    final String wordForHintCheck =
        currentChallenge.wordToLearn?.isNotEmpty == true
            ? currentChallenge.wordToLearn!
            : currentChallenge.question;
    final isNewWord =
        !ref.watch(userDataProvider).seenWords.contains(wordForHintCheck);
    final streak = ref.watch(userDataProvider).currentStreak;

    final buttonBackgroundColor =
        _isAnswered
            ? colorTheme.tertiary
            : (_canContinue
                ? colorTheme.tertiaryContainer
                : colorTheme.surface);

    final buttonBorderColor =
        _isAnswered
            ? colorTheme.tertiary
            : (_canContinue ? colorTheme.tertiary : colorTheme.outline);

    final buttonTextColor = colorTheme.onPrimary;

    // Then use in the button:
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                ProgressBar(
                  currentQuestion: _currentIndex + 1,
                  totalQuestions: challenges.length,
                  streak: streak,
                  onClose: _showExitDialogOverlay,
                ),
                if (isNewWord)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        top: 8,
                        bottom: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/images/KataBaru.svg',
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Kata Baru',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorTheme.tertiary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      currentChallenge.instruction,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: const Color(0xFF61450F),
                      ),
                    ),
                  ),
                ),
                Expanded(child: _buildChallengeCard(isNewWord)),
              ],
            ),
            if (!_showResult)
              Positioned(
                left: 20,
                right: 20,
                bottom: 12,
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: buttonBorderColor, width: 1),
                        left: BorderSide(color: buttonBorderColor, width: 1),
                        right: BorderSide(color: buttonBorderColor, width: 1),
                        bottom: BorderSide(color: buttonBorderColor, width: 3),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ElevatedButton(
                      onPressed:
                          (_canContinue && !_isAnswered) ? _onContinue : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide.none,
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _isAnswered ? 'Lanjutkan' : 'Periksa',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: buttonTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (_showResult)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ResultDialog(
                  isCorrect: _isCorrect,
                  correctAnswer: _correctAnswerText,
                  onContinue: _onContinue,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeCard(bool isNewWord) {
    if (currentChallenge.challengeType == ChallengeType.multipleChoice) {
      return QuestionCard(
        key: ValueKey(_currentIndex),
        options: currentChallenge.options!,
        question: currentChallenge.question,
        isNewWord: isNewWord,
        selectedIndex: _selectedIndex,
        onOptionSelected: _onOptionSelected,
        isAnswered: _isAnswered,
        correctIndex: _correctIndex,
      );
    } else {
      return OrderingCard(
        key: ValueKey(_currentIndex),
        options: currentChallenge.options!,
        question: currentChallenge.question,
        isNewWord: isNewWord,
        selectedWordIndices: _selectedWordIndices,
        onWordIndicesChanged: _onWordIndicesChanged,
        isAnswered: _isAnswered,
        isCorrect: _isCorrect,
      );
    }
  }
}

//asdasdas
