import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'navigation/page_route.dart';
import 'theme/theme.dart';
import 'theme/util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Get.put(BottomNavbarController()); // inject controller GetX

  //proses menghidupkan cache dari firestore offline
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED, // Opsional: unlimited cache
  );

  final prefs = await SharedPreferencesWithCache.create(
    cacheOptions: SharedPreferencesWithCacheOptions(),
  );
  final bool onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
  runApp(ProviderScope(child: MyApp(onboardingComplete: onboardingComplete)));
}

class MyApp extends StatelessWidget {
  final bool onboardingComplete;
  const MyApp({super.key, required this.onboardingComplete});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Nunito", "PT Serif");
    MaterialTheme theme = MaterialTheme(textTheme);
    return GetMaterialApp(
      // <--- WAJIB GetMaterialApp
      debugShowCheckedModeBanner: false,
      title: 'Adibasa App',
      theme: theme.light(),
      initialRoute:
          onboardingComplete
              ? '/bottom_navbar' // langusung masuk ke aplikasi
              : '/onboarding', // masuk onboaridng dulu
      getPages: PageRouteApp.pages, // pakai route yang sudah kamu buat
    );
  }
}
