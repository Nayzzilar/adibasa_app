import 'package:get/get.dart';
import 'package:adibasa_app/screens/beranda.dart';
import 'package:adibasa_app/screens/kamus.dart';
import 'package:adibasa_app/navigation/route_name.dart';

class PageRouteApp {
  static final pages = [
    // GetPage(
    //   name: RouteName.splash , 
    //   page: () => const SplashScreen()
    // ),
    GetPage(
      name: RouteName.kamus , 
      page: () =>  Kamus()
    ),
    GetPage(
      name: RouteName.beranda,
      page: () => const Beranda(),
    ),
    // GetPage(
    //   name: RouteName.koleksi , 
    //   page: () =>  Koleksi()
    // ),
  ];
}