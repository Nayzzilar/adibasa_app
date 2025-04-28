import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'theme/util.dart';
import 'theme/theme.dart';
import 'screens/level_selection_page.dart'; // Import LevelSelectionPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp();
  print("Firebase initialized: ${app.name}");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Nunito", "PT Serif");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme.light(),
      home: const LevelSelectionPage(), // Set LevelSelectionPage as the home
    );
  }
}