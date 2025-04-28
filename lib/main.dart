import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'theme/util.dart';
import 'theme/theme.dart';

// Tambahkan import ini:
import 'screens/game/game_done.dart';

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
      // Ubah home jadi DoneScreen()
      home: const DoneScreen(),
    );
  }
}
