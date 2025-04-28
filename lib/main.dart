import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme/util.dart';
import 'theme/theme.dart';
import 'navigation/page_route.dart';
import 'navigation/bottom_navbar_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  Get.put(BottomNavbarController()); // inject controller GetX

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Nunito", "PT Serif");
    MaterialTheme theme = MaterialTheme(textTheme);

    return GetMaterialApp( // <--- WAJIB GetMaterialApp
      debugShowCheckedModeBanner: false,
      title: 'Adibasa App',
      theme: theme.light(),
      initialRoute: '/beranda', // langsung ke beranda
      getPages: PageRouteApp.pages, // pakai route yang sudah kamu buat
    );
  }
}
