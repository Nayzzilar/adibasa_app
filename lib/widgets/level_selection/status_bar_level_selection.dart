import 'package:adibasa_app/providers/lessons_provider.dart';
import 'package:adibasa_app/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class StatusBarLevelSelection extends StatelessWidget {
  const StatusBarLevelSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
      ),
      child: StatusInfoRow(headline: true),
    );
  }
}

class StatusInfoRow extends StatelessWidget {
  final bool headline;
  const StatusInfoRow({this.headline = false});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final lessonsAsync = ref.watch(lessonsProvider);
        final textStyle = headline
            ? Theme.of(context).textTheme.headlineLarge
            : Theme.of(context).textTheme.titleMedium;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/images/streak.svg', width: 24, height: 24),
                const SizedBox(width: 6),
                Text(
                  '${ref.watch(userDataProvider.select((data) => data.currentStreak))}',
                  style: textStyle,
                ),
                const SizedBox(width: 18),
                SvgPicture.asset('assets/star/star_active.svg', width: 24, height: 24),
                const SizedBox(width: 6),
                Text(
                  '${ref.watch(userDataProvider.select((data) => data.totalStars))}',
                  style: textStyle,
                ),
              ],
            ),
            lessonsAsync.when(
              loading: () => Text('0 / 0', style: textStyle),
              error: (error, stack) => Text('Error', style: textStyle),
              data: (lessons) => Text(
                'Level ${ref.watch(userDataProvider.notifier).nextLessonOrder}/${lessons.length}',
                style: textStyle,
              ),
            ),
          ],
        );
      },
    );
  }
}
