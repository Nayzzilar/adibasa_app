import 'package:adibasa_app/models/level.dart';
import 'package:adibasa_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LevelUnlocked extends StatelessWidget {
  final Level level;
  final VoidCallback? onTap; // Optional callback for tap events
  const LevelUnlocked({super.key, required this.level, this.onTap});

  @override
  Widget build(BuildContext context) {
    final finishedCardTheme =
        Theme.of(context).extension<CustomCardThemes>()?.finishedCardTheme;
    final borderColor = Theme.of(context).colorScheme.tertiary;

    return Padding(
      padding: const EdgeInsets.only(
        right: 16,
        left: 16,
        bottom: 10,
      ), // Konsisten dengan LevelLocked
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: finishedCardTheme?.color,
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
            borderRadius:
                finishedCardTheme?.shape is RoundedRectangleBorder
                    ? (finishedCardTheme!.shape as RoundedRectangleBorder)
                            .borderRadius
                        as BorderRadius?
                    : BorderRadius.circular(8),
            onTap: onTap,
            splashColor: Theme.of(context).colorScheme.primary,
            child: SizedBox(
              height: 72, // Menggunakan shape dari finishedCardTheme
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
                          '${level.name}:', // Nama level
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.primaryContainer, // Warna font
                          ),
                        ),

                        // Level Description
                        Text(
                          level.description, // Deskripsi level
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.primaryContainer, // Warna font
                          ),
                        ),
                      ],
                    ),

                    // Bagian Kanan: Ikon Bintang
                    Row(
                      children: List.generate(3, (index) {
                        final isActive = level.stars > index;

                        // Optional offset if you still want to shift the middle star
                        final offset = index == 1 ? Offset(0, -8) : Offset.zero;

                        return Transform.translate(
                          offset: offset,
                          child: SvgPicture.asset(
                            isActive
                                ? 'assets/star/star_active.svg'
                                : 'assets/star/star_inactive.svg',
                            height: 30,
                            width: 30,
                          ),
                        );
                      }),
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
