import 'package:adibasa_app/models/level.dart';
import 'package:adibasa_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:popover/popover.dart';
import 'level_popup.dart';

class LevelUnlocked extends StatelessWidget {
  final Level level;
  final VoidCallback? onTap; // Optional callback for tap events
  const LevelUnlocked({super.key, required this.level, this.onTap});

  @override
  Widget build(BuildContext context) {
    final finishedCardTheme =
        Theme.of(context).extension<CustomCardThemes>()?.finishedCardTheme;
    final borderColor = Theme.of(context).colorScheme.tertiary;
    final borderColorCurrent = Theme.of(context).colorScheme.outline;
    final isCurrentLevel = level.stars == 0;

    // Tentukan warna background berdasarkan status level
    final backgroundColor =
        isCurrentLevel
            ? Theme.of(context)
                .colorScheme
                .surface // atau warna khusus untuk current level
            : finishedCardTheme?.color;

    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          child: InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap:
                () => showPopover(
                  context: context,
                  bodyBuilder:
                      (context) => LevelPopup(onTap: onTap, level: level),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  direction: PopoverDirection.top,
                ),
            splashColor: Theme.of(context).colorScheme.outline,
            child: SizedBox(
              width: 50,
              height: 58, // Lebih tinggi dari lingkaran (50) + bintang (18)
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Lingkaran medali dengan angka level di tengah
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: backgroundColor,
                        border: Border(
                          top: BorderSide(
                            color:
                                isCurrentLevel
                                    ? borderColorCurrent
                                    : borderColor,
                            width: 2,
                          ),
                          left: BorderSide(
                            color:
                                isCurrentLevel
                                    ? borderColorCurrent
                                    : borderColor,
                            width: 2,
                          ),
                          right: BorderSide(
                            color:
                                isCurrentLevel
                                    ? borderColorCurrent
                                    : borderColor,
                            width: 2,
                          ),
                          bottom: BorderSide(
                            color:
                                isCurrentLevel
                                    ? borderColorCurrent
                                    : borderColor,
                            width: 6,
                          ),
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
                        child: Text(
                          '${level.level}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
                  ),
                  // Bintang tepat di bawah lingkaran
                  Positioned(
                    bottom: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.rotate(
                          angle: 0.314,
                          child: Transform.translate(
                            offset: const Offset(0, -4),
                            child: SvgPicture.asset(
                              level.stars > 0
                                  ? 'assets/star/star_active.svg'
                                  : 'assets/star/star_inactive.svg',
                              height: 18,
                              width: 18,
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, 0),
                          child: SvgPicture.asset(
                            level.stars > 1
                                ? 'assets/star/star_active.svg'
                                : 'assets/star/star_inactive.svg',
                            height: 18,
                            width: 18,
                          ),
                        ),
                        Transform.rotate(
                          angle: -0.314,
                          child: Transform.translate(
                            offset: const Offset(0, -4),
                            child: SvgPicture.asset(
                              level.stars > 2
                                  ? 'assets/star/star_active.svg'
                                  : 'assets/star/star_inactive.svg',
                              height: 18,
                              width: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
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
