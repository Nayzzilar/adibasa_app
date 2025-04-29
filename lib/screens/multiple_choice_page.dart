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
  OverlayEntry? _overlayEntry;
  bool _isPopupVisible = false;
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

  void _onNewWordTap(String word, String meaning, GlobalKey key) {
    if (_isPopupVisible) {
      _hideNewWordBubble();
      return;
    }

    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Size screenSize = MediaQuery.of(context).size;
    final double maxWidth = screenSize.width * 0.7;
    final double maxHeight = 100; // Approximate height of popup
    final double padding = 8.0; // Space between word and popup

    final Offset wordPosition = renderBox.localToGlobal(Offset.zero);
    final Size wordSize = renderBox.size;

    // Calculate initial position (right of word)
    double dx = wordPosition.dx + wordSize.width + padding;
    double dy = wordPosition.dy + (wordSize.height / 2) - (maxHeight / 2);

    // If popup would go off right edge, position it to the left of the word
    if (dx + maxWidth > screenSize.width - padding) {
      dx = wordPosition.dx - maxWidth - padding;
    }

    // If popup would go off left edge, position it at left edge with padding
    if (dx < padding) {
      dx = padding;
    }

    // If popup would go off top edge, position it below the word
    if (dy < padding) {
      dy = wordPosition.dy + wordSize.height + padding;
    }

    // If popup would go off bottom edge, position it above the word
    if (dy + maxHeight > screenSize.height - padding) {
      dy = wordPosition.dy - maxHeight - padding;
    }

    _showNewWordBubble(word, meaning, Offset(dx, dy));
  }

  void _handleNewWordTap(GlobalKey key) {
    final currentQuestion = _questions[_currentIndex];
    
    // Extract the word between quotes and remove all HTML formatting
    String cleanWord = '';
    final match = RegExp(r'"([^"]*)"').firstMatch(currentQuestion['question']);
    if (match != null) {
      cleanWord = match.group(1) ?? '';
      // Remove any HTML tags including underline
      cleanWord = cleanWord
          .replaceAll(RegExp(r'<u>|</u>'), '')  // Remove underline tags
          .replaceAll(RegExp(r'<[^>]*>'), '')   // Remove any other HTML tags
          .trim();
    }

    final correctOption = currentQuestion['options'].firstWhere((o) => o['correct'] == true);
    final meaning = correctOption['text'];
    
    // Find position relative to the word in question
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final Size screenSize = MediaQuery.of(context).size;
      final Offset wordPosition = renderBox.localToGlobal(Offset.zero);
      final Size wordSize = renderBox.size;
      
      double dx = wordPosition.dx + wordSize.width + 12.0;
      double dy = wordPosition.dy - 8.0;
      
      _showNewWordBubble(cleanWord, meaning, Offset(dx, dy));
    }
  }

  void _showNewWordBubble(String word, String meaning, Offset position) {
    setState(() => _isPopupVisible = true);
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _hideNewWordBubble,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            left: position.dx,
            top: position.dy,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) => Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.25,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFFFA726),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      word,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFFA726),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      meaning,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                        color: Color(0xFF4A4A4A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideNewWordBubble() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
    if (mounted) {
      setState(() => _isPopupVisible = false);
    }
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
                      question: _questions[_currentIndex]['question'],  // Keep original question format
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

  @override
  void dispose() {
    _hideNewWordBubble();
    _audioPlayer.dispose();
    super.dispose();
  }
} 