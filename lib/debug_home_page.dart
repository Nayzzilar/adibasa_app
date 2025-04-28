import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DebugHomePage extends StatelessWidget {
  const DebugHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/gamification');
              },
              child: const Text('Mulai Gamifikasi'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Keluar Aplikasi'),
            ),
          ],
        ),
      ),
    );
  }
} 