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
    final borderColor = Theme.of(context).colorScheme.outline;

    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, bottom: 10),
      child: Material(
        color: lockedCardTheme?.color,
        elevation:
            0, // Hilangkan elevation karena kita menggunakan border custom
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: lockedCardTheme?.color,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              top: BorderSide(color: borderColor, width: 1),
              left: BorderSide(color: borderColor, width: 1),
              right: BorderSide(color: borderColor, width: 1),
              bottom: BorderSide(
                color: borderColor,
                width: 3,
              ), // Border bawah lebih tebal
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 72, // Tinggi tetap untuk card yang terkunci
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
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
                            color:
                                Theme.of(context).colorScheme.surfaceContainer,
                          ),
                        ),
                        // Level Description
                        Text(
                          level.description,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.surfaceContainer,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
