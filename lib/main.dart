import 'package:adibasa_app/providers/duration_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'navigation/bottom_navbar_controller.dart';
import 'navigation/page_route.dart';
import 'providers/star_provider.dart';
import 'providers/streak_provider.dart';
import 'theme/theme.dart';
import 'theme/util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp();

  Get.put(BottomNavbarController()); // inject controller GetX

  //proses menghidupkan cache dari firestore offline
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED, // Opsional: unlimited cache
  );

  final prefs = await SharedPreferencesWithCache.create(
    cacheOptions: SharedPreferencesWithCacheOptions(),
  );
  final bool onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
  print("Firebase initialized: ${app.name}");
  print('onboardingComplete: $onboardingComplete');
  runApp(MyApp(onboardingComplete: onboardingComplete));
}

class MyApp extends StatelessWidget {
  final bool onboardingComplete;
  const MyApp({super.key, required this.onboardingComplete});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Nunito", "PT Serif");
    MaterialTheme theme = MaterialTheme(textTheme);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StreakProvider()),
        ChangeNotifierProvider(create: (_) => StarProvider()),
        ChangeNotifierProvider(create: (_) => DurationProvider()),
      ],
      child: GetMaterialApp(
        // <--- WAJIB GetMaterialApp
        debugShowCheckedModeBanner: false,
        title: 'Adibasa App',
        theme: theme.light(),
        initialRoute: "/kamus",
        // onboardingComplete
        //     ? 'beranda'
        //     : '/onboarding', // langsung ke beranda
        getPages: PageRouteApp.pages, // pakai route yang sudah kamu buat
      ),
    );
  }
}