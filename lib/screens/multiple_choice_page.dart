import 'package:adibasa_app/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/svg.dart';
import '../models/lesson_model.dart';
import '../models/challenge_model.dart';
import '../providers/lesson_game_provider.dart';
import '../widgets/gamification/progress_bar.dart';
import '../widgets/gamification/question_card.dart';
import '../widgets/gamification/result_dialog.dart';
import '../widgets/gamification/exit_dialog.dart';

class MultipleChoicePage extends ConsumerStatefulWidget {
  const MultipleChoicePage({super.key});

  @override
  ConsumerState<MultipleChoicePage> createState() => _MultipleChoicePageState();
}

class _MultipleChoicePageState extends ConsumerState<MultipleChoicePage> {
  int _currentIndex = 0;
  int? _selectedIndex;
  int? _correctIndex;
  bool _isAnswered = false;
  bool _showResult = false;
  bool _isCorrect = false;
  late AudioPlayer _audioPlayer;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Do not access ref.read in initState directly for providers that might change
    // Instead use a Future.microtask to ensure the widget is fully built
    Future.microtask(() {
      // Start the timer using lessonGameProvider
      ref.read(lessonGameProvider.notifier).startTimer();

      // Mark as initialized so build() knows we're ready
      setState(() {
        _isInitialized = true;
      });
    });
  }

  // Get the current lesson from the provider whenever needed
  Lesson? get _currentLesson => ref.read(lessonGameProvider).currentLesson;

  // Get challenges from the current lesson
  List<Challenge> get challenges => _currentLesson?.challenges ?? [];

  void _onOptionSelected(int index) {
    if (_isAnswered) return;
    setState(() => _selectedIndex = index);
  }

  void _onContinue() {
    final userDataNotifier = ref.read(userDataProvider.notifier);
    final currentChallenge = challenges[_currentIndex];
    if (!_isAnswered) {
      setState(() {
        _isAnswered = true;
        _correctIndex =
            currentChallenge.options?.indexWhere((o) => o.correct) ?? -1;
        _isCorrect = _selectedIndex == _correctIndex;
        _showResult = true;
      });

      if (_isCorrect) {
        userDataNotifier.incrementStreak();
      } else {
        _currentLesson!.challenges?.add(currentChallenge);
        userDataNotifier.resetStreak();
      }

      _audioPlayer.stop();
      _audioPlayer.play(
        AssetSource(_isCorrect ? 'audio/success.mp3' : 'audio/failure.mp3'),
      );
      return;
    } else {
      if (_isCorrect) {
        userDataNotifier.addSeenWord(currentChallenge.question);
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
    _correctIndex = null;
  }

  void _handleLevelCompletion() {
    // Using Future.microtask to avoid updating state during widget lifecycle
    Future.microtask(() {
      // Use lessonGameProvider to calculate stars
      // This will stop the timer and calculate stars automatically
      ref.read(lessonGameProvider.notifier).calculateStars();

      ref
          .read(userDataProvider.notifier)
          .completeLesson(
            _currentLesson?.order ?? 0,
            ref.read(lessonGameProvider).stars,
          );
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
              // Stop the timer when exiting the lesson
              ref.read(lessonGameProvider.notifier).stopTimer();
              Navigator.pushReplacementNamed(context, '/bottom_navbar');
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get textTheme for custom fonts
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;

    // Normal lesson UI with challenges
    final currentChallenge = challenges[_currentIndex];
    final isNewWord =
        !ref
            .watch(userDataProvider)
            .seenWords
            .contains(currentChallenge.question);

    final streak = ref.watch(userDataProvider).currentStreak;

    return Scaffold(
      backgroundColor: const Color(0xFFF6E7C1),
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
                            'assets/images/KataBaru.svg', // Path ke gambar
                            width: 20, // Sesuaikan ukuran gambar
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
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 4,
                    bottom: 0,
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
                Expanded(
                  child: QuestionCard(
                    key: ValueKey(_currentIndex),
                    options: currentChallenge.options!,
                    question: currentChallenge.question,
                    isNewWord: isNewWord,
                    selectedIndex: _selectedIndex,
                    onOptionSelected: _onOptionSelected,
                    isAnswered: _isAnswered,
                    correctIndex: _correctIndex,
                  ),
                ),
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
                  child: ElevatedButton(
                    onPressed:
                        (_selectedIndex != null && !_isAnswered)
                            ? _onContinue
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isAnswered
                              ? const Color(0xFF4B6B2D)
                              : (_selectedIndex != null
                                  ? const Color(0xFFB6B96C)
                                  : const Color(0xFFD6D6C2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      _isAnswered ? 'Lanjutkan' : 'Periksa',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
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
                  correctAnswer:
                      _correctIndex != null &&
                              _correctIndex! < currentChallenge.options!.length
                          ? currentChallenge.options![_correctIndex!].text
                          : '',
                  onContinue: _onContinue,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
