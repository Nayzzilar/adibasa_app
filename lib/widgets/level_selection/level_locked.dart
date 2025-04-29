import 'package:adibasa_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:adibasa_app/dummy/levels_dummy.dart';

class LevelLocked extends StatelessWidget {
  final Level level;
  const LevelLocked({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final lockedCardTheme =
        Theme.of(context).extension<CustomCardThemes>()?.lockedCardTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        color: lockedCardTheme?.color, // Menggunakan warna dari lockedCardTheme
        elevation: lockedCardTheme?.elevation ?? 1,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: lockedCardTheme?.shape, // Menggunakan shape dari lockedCardTheme
        margin:
            lockedCardTheme?.margin, // Menggunakan margin dari lockedCardTheme
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
                          ).colorScheme.surfaceContainer, // Warna font
                    ),
                  ),

                  // Level Description
                  Text(
                    level.description, // Deskripsi level
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.surfaceContainer, // Warna font
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
