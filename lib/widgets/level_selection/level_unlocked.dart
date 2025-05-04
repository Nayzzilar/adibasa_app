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

    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, bottom: 10),
      child: Material(
        color: finishedCardTheme?.color,
        elevation: 1,
        shadowColor: Theme.of(context).colorScheme.outline,
        shape: finishedCardTheme?.shape,
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
            height: 72,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Level name + desc
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${level.name}:',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                      Text(
                        level.description,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                    ],
                  ),

                  // Bintang-bintang
                  Row(
                    children: List.generate(3, (index) {
                      final isActive = level.stars > index;
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
    );
  }
}
