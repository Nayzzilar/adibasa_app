import 'package:adibasa_app/screens/level_selection.dart';
import 'package:get/get.dart';
import 'package:adibasa_app/screens/kamus.dart';
import 'package:adibasa_app/navigation/route_name.dart';
import 'package:adibasa_app/navigation/bottom_navbar.dart';

class PageRouteApp {
  static final pages = [
    GetPage(name: RouteName.kamus, page: () => Kamus()),
    GetPage(name: RouteName.level_selection, page: () => LevelSelection()),
    GetPage(name: RouteName.bottonnavbar, page: () => BottomNavbar()),
  ];
}

