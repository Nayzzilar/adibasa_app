import 'package:adibasa_app/utils/enums.dart';
import 'package:adibasa_app/widgets/custom_main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/lesson_game_provider.dart';
import '../widgets/star_rating.dart';
import '../widgets/gamification/card_level_complete.dart';
import '../navigation/route_name.dart';
import 'package:get/get.dart';
import 'package:confetti/confetti.dart';

class LevelCompletePage extends ConsumerStatefulWidget {
  const LevelCompletePage({Key? key}) : super(key: key);

  @override
  ConsumerState<LevelCompletePage> createState() => _LevelCompletePageState();
}

class _LevelCompletePageState extends ConsumerState<LevelCompletePage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final gameState = ref.read(lessonGameProvider);
    final stars = gameState.stars;
    final duration = gameState.duration;
    final correct = gameState.challengesCorrect;
    final wrong = gameState.challengesWrong;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.1),
              width: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    emissionFrequency: 0.1,
                    numberOfParticles: 20,
                    gravity: 0.3,
                    maxBlastForce: 10,
                    minBlastForce: 5,
                    colors: const [
                      Color(0xFF59471D),
                      Color(0xFF498C4C),
                      Color(0xFF49758C),
                      Color(0xFFE0900F),
                      Color(0xFFE47B2A),
                      Color(0xFfEEBB5F),
                      Color(0xFF8BC733),
                    ],
                  ),
                  Image.asset(
                    'assets/images/badak_tepuk_tangan.png',
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.02),
              height: screenHeight * 0.2,
              child: StarRating(
                starCount: stars,
                size: screenWidth * 0.2,
                spacing: screenWidth * 0.02,
              ),
            ),

            CardLevelComplete(
              duration: duration,
              correctPercentage:
                  wrong == 0
                      ? 100
                      : (correct / (correct + wrong) * 100).toInt(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: CustomMainButton(
          label: 'Lanjutkan',
          onPressed: () {
            Get.offAllNamed(RouteName.bottomNavbar);
          },
          variant: ButtonVariant.primary,
        ),
      ),
    );
  }
}
