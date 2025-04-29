import 'package:adibasa_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:adibasa_app/dummy/levels_dummy.dart';

class LevelUnlocked extends StatelessWidget {
  final Level level;
  const LevelUnlocked({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final finishedCardTheme =
        Theme.of(context).extension<CustomCardThemes>()?.finishedCardTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ), // Konsisten dengan LevelLocked
      child: Card(
        color:
            finishedCardTheme
                ?.color, // Menggunakan warna dari finishedCardTheme
        elevation: finishedCardTheme?.elevation ?? 1,
        shadowColor: Colors.black.withOpacity(0.1),
        shape:
            finishedCardTheme
                ?.shape, // Menggunakan shape dari finishedCardTheme
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bagian Kiri: Level Name dan Description
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Level Name
                  Text(
                    '${level.name}:', // Nama level
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.primaryContainer, // Warna font
                    ),
                  ),

                  // Level Description
                  Text(
                    level.description, // Deskripsi level
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.primaryContainer, // Warna font
                    ),
                  ),
                ],
              ),

              // Bagian Kanan: Ikon Bintang
              Image.asset(
                'assets/${level.stars}_stars.png', // Ganti ikon berdasarkan jumlah bintang
                height: 50,
                width: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
