import 'package:adibasa_app/screens/level_selection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme/util.dart';
import 'theme/theme.dart';
import 'package:adibasa_app/screens/multiple_choice_page.dart';
import 'debug_home_page.dart';
import 'screens/level_complete_page.dart';
import 'package:provider/provider.dart';
import 'providers/star_provider.dart';
import 'providers/streak_provider.dart';
import 'package:adibasa_app/services/question_service.dart';
import 'screens/level_selection_page.dart';
import 'navigation/page_route.dart';
import 'navigation/bottom_navbar_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  Get.put(BottomNavbarController()); // inject controller GetX

  //proses menghidupkan cache dari firestore offline
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED, // Opsional: unlimited cache
  );

  print("Firebase initialized: ${app.name}");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Nunito", "PT Serif");
    MaterialTheme theme = MaterialTheme(textTheme);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StreakProvider()),
        ChangeNotifierProvider(create: (_) => StarProvider()),
      ],
      child: GetMaterialApp( // <--- WAJIB GetMaterialApp
        debugShowCheckedModeBanner: false,
        title: 'Adibasa App',
        theme: theme.light(),
        home: MultipleChoicePage(),
        routes: {
          '/gamification': (context) => MultipleChoicePage(),
          '/level-complete': (context) => LevelCompletePage(),
        },
        initialRoute: '/beranda', // langsung ke beranda
        getPages: PageRouteApp.pages, // pakai route yang sudah kamu buat
      ),
    );
  }
}
