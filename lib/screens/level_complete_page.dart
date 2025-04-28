import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/star_provider.dart';
import '../providers/streak_provider.dart';

class LevelCompletePage extends StatelessWidget {
  const LevelCompletePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final streak = Provider.of<StreakProvider>(context, listen: false).streak;
    final star = Provider.of<StarProvider>(context, listen: false).star;
    return Scaffold(
      appBar: AppBar(title: const Text('Level Selesai')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Level Selesai!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            Text('Streak terakhir: $streak', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            Text('Bintang didapat: $star', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Kembali ke Home'),
            ),
          ],
        ),
      ),
    );
  }
} 