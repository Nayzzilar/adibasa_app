import 'package:adibasa_app/screens/level_complete_page.dart';
import 'package:adibasa_app/screens/level_selection.dart';
import 'package:adibasa_app/screens/onboarding.dart';
import 'package:get/get.dart';
import 'package:adibasa_app/screens/kamus.dart';
import 'package:adibasa_app/navigation/route_name.dart';
import 'package:adibasa_app/navigation/bottom_navbar.dart';
import 'package:adibasa_app/screens/challenge_screen.dart';

class PageRouteApp {
  static final pages = [
    GetPage(name: RouteName.kamus, page: () => Kamus()),
    GetPage(name: RouteName.levelSelection, page: () => LevelSelection()),
    GetPage(name: RouteName.bottomNavbar, page: () => BottomNavbar()),
    GetPage(name: RouteName.onboarding, page: () => OnboardingScreen()),
    GetPage(name: RouteName.levelComplete, page: () => LevelCompletePage()),
    GetPage(name: RouteName.questions, page: () => const ChallengeScreen()),
  ];
}
