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
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              top: BorderSide(
                color: isCurrentLevel ? borderColorCurrent : borderColor,
                width: 1,
              ),
              left: BorderSide(
                color: isCurrentLevel ? borderColorCurrent : borderColor,
                width: 1,
              ),
              right: BorderSide(
                color: isCurrentLevel ? borderColorCurrent : borderColor,
                width: 1,
              ),
              bottom: BorderSide(
                color: isCurrentLevel ? borderColorCurrent : borderColor,
                width: 3,
              ),
            ),
          ),
          child: InkWell(
            borderRadius:
                finishedCardTheme?.shape is RoundedRectangleBorder
                    ? (finishedCardTheme!.shape as RoundedRectangleBorder)
                            .borderRadius
                        as BorderRadius?
                    : BorderRadius.circular(8),
            //onTap: onTap,
            onTap:
                () => showPopover(
                  context: context,
                  bodyBuilder:
                      (context) => LevelPopup(onTap: onTap, level: level),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  direction: PopoverDirection.top, // atau sesuai kebutuhan
                  // barrierColor: Colors.transparent,
                  // arrowHeight: 21,
                  // arrowWidth: 21,
                  //alignment: PopoverAlignment.center,
                ),
            splashColor: Theme.of(context).colorScheme.outline,
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
