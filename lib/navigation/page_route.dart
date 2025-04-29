import 'package:adibasa_app/screens/level_complete_page.dart';
import 'package:adibasa_app/screens/multiple_choice_page.dart';
import 'package:get/get.dart';
import 'package:adibasa_app/screens/kamus.dart';
import 'package:adibasa_app/navigation/route_name.dart';
import 'package:adibasa_app/screens/level_selection.dart';

class PageRouteApp {
  static final pages = [
    // GetPage(
    //   name: RouteName.splash ,
    //   page: () => const SplashScreen()
    // ),
    GetPage(name: RouteName.kamus, page: () => const Kamus()),
    GetPage(name: RouteName.beranda, page: () => const LevelSelection()),
    GetPage(name: RouteName.gamification, page: () => const MultipleChoicePage()),
    GetPage(name: RouteName.levelComplete, page: () => const LevelCompletePage()),
    // GetPage(
    //   name: RouteName.koleksi ,
    //   page: () =>  Koleksi()
    // ),
  ];
}

