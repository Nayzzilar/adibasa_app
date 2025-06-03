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
        color: Colors.transparent,
        elevation:
            0, // Hilangkan elevation karena kita menggunakan border custom
        child: Ink(
          child: InkWell(
            borderRadius: BorderRadius.circular(40),
            splashColor: Theme.of(context).colorScheme.outline,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Lingkaran medali dengan angka level di tengah
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(
                      top: BorderSide(color: borderColor, width: 2),
                      left: BorderSide(color: borderColor, width: 2),
                      right: BorderSide(color: borderColor, width: 2),
                      bottom: BorderSide(color: borderColor, width: 6),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons
                          .lock, // Use the lock icon from Flutter's material icons
                      size: 24,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
