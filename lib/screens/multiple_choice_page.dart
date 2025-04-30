import 'dart:convert';
import 'package:adibasa_app/widgets/gamification/question_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/duration_provider.dart';
import '../widgets/gamification/progress_bar.dart';
import '../widgets/gamification/result_dialog.dart';
import '../widgets/gamification/exit_dialog.dart';
import '../widgets/gamification/new_word_popup.dart';
import '../providers/star_provider.dart';
import '../providers/streak_provider.dart';
import 'package:provider/provider.dart';

class MultipleChoicePage extends StatefulWidget {
  const MultipleChoicePage({Key? key}) : super(key: key);

  @override
  State<MultipleChoicePage> createState() => _MultipleChoicePageState();
}

class _MultipleChoicePageState extends State<MultipleChoicePage> {
  List<dynamic> _questions = [];
  int _currentIndex = 0;
  int? _selectedIndex;
  bool _isAnswered = false;
  int? _correctIndex;
  bool _showResult = false;
  bool _isCorrect = false;
  bool _showNewWordPopup = false;
  String _newWord = '';
  String _newWordMeaning = '';
  DateTime? _levelStartTime;
  OverlayEntry? _popupEntry;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _levelStartTime = DateTime.now();
  }

  Future<void> _loadQuestions() async {
    final String data = await rootBundle.loadString(
      'assets/dummy/greetings_lessons.json',
    );
    final List<dynamic> jsonResult = json.decode(data);
    setState(() {
      _questions = jsonResult[0]['challenges'];
    });
  }

  void _onOptionSelected(int index) {
    if (_isAnswered) return;
    setState(() {
      _selectedIndex = index;
      _isAnswered = true;
      _correctIndex = _questions[_currentIndex]['options'].indexWhere(
        (o) => o['correct'] == true,
      );
      _isCorrect = _selectedIndex == _correctIndex;
      _showResult = true;
    });
    if (_isCorrect) {
      Provider.of<StreakProvider>(context, listen: false).incrementStreak();
    } else {
      Provider.of<StreakProvider>(context, listen: false).resetStreak();
    }
  }

  void _onContinue() {
    _hideNewWordBubble();
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _showResult = false;
        _isAnswered = false;
        _selectedIndex = null;
        _correctIndex = null;
        _currentIndex++;
      });
    } else {
      // Hitung star berdasarkan durasi level
      final endTime = DateTime.now();
      final duration = endTime.difference(_levelStartTime ?? endTime);
      Provider.of<DurationProvider>(
        context,
        listen: false,
      ).setDuration(duration);
      Provider.of<StarProvider>(context, listen: false).calculateStar(duration);
      // Navigasi ke halaman LevelCompletePage
      Navigator.of(context).pushReplacementNamed('/level-complete');
    }
  }

  void _onNewWordTap(GlobalKey key, String word, String meaning) {
    if (_popupEntry != null && _newWord == word) {
      _hideNewWordBubble();
      return;
    }
    setState(() {
      _newWord = word;
      _newWordMeaning = meaning;
    });
    _hideNewWordBubble();
    _showNewWordBubble(context, key);
  }

  void _showNewWordBubble(BuildContext context, GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final offset = renderBox?.localToGlobal(Offset.zero) ?? Offset(100, 100);
    _popupEntry = OverlayEntry(
      builder:
          (context) => NewWordPopup(
            word: _newWord,
            meaning: _newWordMeaning,
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
            onContinue: () {
              Navigator.of(context).pop();
            },
            onExit: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion =
        _questions.isNotEmpty ? _questions[_currentIndex] : null;
    final isNewWord =
        currentQuestion != null && currentQuestion['type'] == 'NEW_WORD';
    String? newWord;
    String? newWordMeaning;
    if (isNewWord && currentQuestion != null) {
      final match = RegExp(
        r'"([^"]+)"',
      ).firstMatch(currentQuestion['question']);
      newWord = match != null ? match.group(1) ?? '' : '';
      final correctOption = currentQuestion['options'].firstWhere(
        (o) => o['correct'] == true,
      );
      newWordMeaning = correctOption['text'];
    }
    return Scaffold(
      appBar: null,
      body:
          _questions.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Consumer<StreakProvider>(
                    builder: (context, streakProvider, _) {
                      return ProgressBar(
                        currentQuestion: _currentIndex + 1,
                        totalQuestions: _questions.length,
                        streak: streakProvider.streak,
                        onClose: _showExitDialogOverlay,
                      );
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isNewWord)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              top: 8,
                              bottom: 4,
                            ),
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
                            question: currentQuestion['question'],
                            options: List<String>.from(
                              currentQuestion['options'].map((o) => o['text']),
                            ),
                            selectedIndex: _selectedIndex,
                            onOptionSelected: (index) {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            isAnswered: _isAnswered,
                            correctIndex: _correctIndex,
                            isNewWord: isNewWord,
                            onNewWordTap:
                                isNewWord &&
                                        newWord != null &&
                                        newWordMeaning != null
                                    ? (key) => _onNewWordTap(
                                      key,
                                      newWord!,
                                      newWordMeaning!,
                                    )
                                    : null,
                            onNewWordBubbleClose: _hideNewWordBubble,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child:
                          (_showResult)
                              ? const SizedBox.shrink()
                              : (_isAnswered
                                  ? ElevatedButton(
                                    onPressed: _onContinue,
                                    style: ElevatedButton.styleFrom(),
                                    child: const Text('Lanjutkan'),
                                  )
                                  : ElevatedButton(
                                    onPressed:
                                        _selectedIndex != null
                                            ? () {
                                              _onOptionSelected(
                                                _selectedIndex!,
                                              );
                                            }
                                            : null,
                                    style: ElevatedButton.styleFrom(),
                                    child: const Text('Periksa'),
                                  )),
                    ),
                  ),
                ],
              ),
      floatingActionButton: null,
      bottomSheet:
          (_showResult
              ? ResultDialog(
                isCorrect: _isCorrect,
                correctAnswer:
                    _questions[_currentIndex]['options'][_correctIndex ??
                        0]['text'],
                onContinue: _onContinue,
              )
              : null),
    );
  }
}

