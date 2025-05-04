import 'package:adibasa_app/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/lesson_model.dart';
import '../models/challenge_model.dart';
import '../providers/current_lesson_provider.dart';
import '../providers/duration_provider.dart';
import '../providers/star_provider.dart';
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
  DateTime? _levelStartTime;
  late AudioPlayer _audioPlayer;
  late Lesson _currentLesson;

  @override
  void initState() {
    super.initState();
    _currentLesson = ref.read(currentLessonProvider)!;
    _audioPlayer = AudioPlayer();
    ref.read(durationProvider.notifier).start();
  }

  List<Challenge> get challenges => _currentLesson.challenges ?? [];

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
        userDataNotifier.resetStreak();
      }

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
    final durationNotifier = ref.read(durationProvider.notifier);
    durationNotifier.stop();
    final duration = ref.read(durationProvider);

    ref.read(starProvider.notifier).calculateStar(duration);
    ref
        .read(userDataProvider.notifier)
        .completeLesson(_currentLesson.order, ref.read(starProvider));
    Navigator.pushReplacementNamed(context, '/level_complete');
  }

  void _showExitDialogOverlay() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => ExitDialog(
            onContinue: () => Navigator.pop(context),
            onExit: () {
              Navigator.pushReplacementNamed(context, '/bottom_navbar');
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (challenges.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No challenges available')),
      );
    }

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
                          Image.asset(
                            'assets/images/KataBaru.png',
                            width: 18,
                            height: 18,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Kata Baru',
                            style: TextStyle(
                              color: Color(0xFFFFA726),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ],
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
                      style: const TextStyle(
                        fontFamily: 'Nunito',
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

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
