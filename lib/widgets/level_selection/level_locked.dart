import 'package:adibasa_app/models/level.dart';
import 'package:adibasa_app/theme/theme.dart';
import 'package:flutter/material.dart';

class LevelLocked extends StatelessWidget {
  final Level level;
  const LevelLocked({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final lockedCardTheme =
        Theme.of(context).extension<CustomCardThemes>()?.lockedCardTheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: Card(
        // Gunakan properti card untuk shadow
        color: lockedCardTheme?.color,
        elevation: 1, // Gunakan nilai elevation yang konsisten
        shadowColor:
            Theme.of(
              context,
            ).colorScheme.outline, // Warna shadow yang lebih konsisten
        shape: lockedCardTheme?.shape,
        margin: lockedCardTheme?.margin,
        child: SizedBox(
          height: 72, // Tinggi tetap untuk card yang terkunci
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Bagian Kiri: Level Name dan Description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Level Name
                    Text(
                      '${level.name}:',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                      ),
                    ),
                    // Level Description
                    Text(
                      level.description,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
