import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/gamification/progress_bar.dart';
import '../widgets/gamification/question_card.dart';
import '../widgets/gamification/result_dialog.dart';
import '../widgets/gamification/exit_dialog.dart';
import '../widgets/gamification/new_word_popup.dart';
import '../providers/star_provider.dart';
import '../providers/streak_provider.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

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
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _levelStartTime = DateTime.now();
  }

  Future<void> _loadQuestions() async {
    final String data = await rootBundle.loadString('assets/dummy/greetings_lessons.json');
    final List<dynamic> jsonResult = json.decode(data);
    setState(() {
      _questions = jsonResult[0]['challenges'];
    });
  }

  void _onOptionSelected(int index) {
    if (_isAnswered) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onContinue() {
    if (!_isAnswered) {
      setState(() {
        _isAnswered = true;
        _correctIndex = _questions[_currentIndex]['options'].indexWhere((o) => o['correct'] == true);
        _isCorrect = _selectedIndex == _correctIndex;
        _showResult = true;
      });
      // Update streak immediately
      if (_isCorrect) {
        Provider.of<StreakProvider>(context, listen: false).incrementStreak();
      } else {
        Provider.of<StreakProvider>(context, listen: false).resetStreak();
      }
      // Play audio only when showing result
      Future.microtask(() {
        final player = AudioPlayer();
        player.play(AssetSource(_isCorrect ? 'audio/success.mp3' : 'audio/failure.mp3'));
      });
      return;
    }
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

  void _handleNewWordTap(GlobalKey key) {
    final currentQuestion = _questions[_currentIndex];
    final match = RegExp(r'"([^"]+)"').firstMatch(currentQuestion['question']);
    if (match != null) {
      final word = match.group(1) ?? '';
      final correctOption = currentQuestion['options'].firstWhere((o) => o['correct'] == true);
      final meaning = correctOption['text'];
      _onNewWordTap(key, word, meaning);
    }
  }

  void _showNewWordBubble(BuildContext context, GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final offset = renderBox?.localToGlobal(Offset.zero) ?? Offset(100, 100);
    _popupEntry = OverlayEntry(
      builder: (context) => NewWordPopup(
        word: _newWord,
        meaning: _newWordMeaning,
        position: Offset(offset.dx + renderBox!.size.width + 8, offset.dy - 8),
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
      builder: (context) => ExitDialog(
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
    final currentQuestion = _questions.isNotEmpty ? _questions[_currentIndex] : null;
    final isNewWord = currentQuestion != null && currentQuestion['type'] == 'NEW_WORD';
    String? newWord;
    String? newWordMeaning;
    if (isNewWord && currentQuestion != null) {
      final match = RegExp(r'"([^"]+)"').firstMatch(currentQuestion['question']);
      newWord = match != null ? match.group(1) ?? '' : '';
      final correctOption = currentQuestion['options'].firstWhere((o) => o['correct'] == true);
      newWordMeaning = correctOption['text'];
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF6E7C1),
      appBar: null,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // ProgressBar only if questions loaded
                if (_questions.isNotEmpty)
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Consumer<StreakProvider>(
                            builder: (context, streakProvider, _) {
                              return ProgressBar(
                                currentQuestion: _currentIndex + 1,
                                totalQuestions: _questions.length,
                                streak: streakProvider.streak,
                                onClose: _showExitDialogOverlay,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                if (_questions.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(),
                  ),
                // Always show 'Kata Baru' left-aligned if current question is NEW_WORD
                if (_questions.isNotEmpty && _questions[_currentIndex]['type'] == 'NEW_WORD')
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
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
                if (_questions.isNotEmpty)
                  Expanded(
                    child: QuestionCard(
                      key: ValueKey(_currentIndex),
                      question: _questions[_currentIndex]['question'],
                      options: List<String>.from(_questions[_currentIndex]['options'].map((o) => o['text'])),
                      selectedIndex: _selectedIndex,
                      onOptionSelected: _onOptionSelected,
                      isAnswered: _isAnswered,
                      correctIndex: _correctIndex,
                      isNewWord: _questions[_currentIndex]['type'] == 'NEW_WORD',
                      onNewWordTap: _questions[_currentIndex]['type'] == 'NEW_WORD' ? _handleNewWordTap : null,
                      onNewWordBubbleClose: _hideNewWordBubble,
                    ),
                  ),
              ],
            ),
            // Main button at the bottom (only if !_showResult)
            if (_questions.isNotEmpty && !_showResult)
              Positioned(
                left: 20,
                right: 20,
                bottom: 12,
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: (_selectedIndex != null && !_isAnswered) ? _onContinue : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isAnswered ? const Color(0xFF4B6B2D) : (_selectedIndex != null ? const Color(0xFFB6B96C) : const Color(0xFFD6D6C2)),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      textStyle: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 16),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(_isAnswered ? 'Lanjutkan' : 'Periksa'),
                  ),
                ),
              ),
            // ResultDialog at the very bottom (only if _showResult)
            if (_showResult)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ResultDialog(
                  isCorrect: _isCorrect,
                  correctAnswer: _questions[_currentIndex]['options']
                      .firstWhere((o) => o['correct'] == true)['text'],
                  onContinue: _onContinue,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: null,
      bottomSheet: null,
    );
  }
} 