import 'package:adibasa_app/providers/lessons_provider.dart';
import 'package:adibasa_app/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class StatusBarLevelSelection extends ConsumerWidget {
  const StatusBarLevelSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(lessonsProvider); // Akses lessonsProvider
    final colorScheme =
        Theme.of(context).colorScheme; // Ambil colorScheme dari tema

    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
      child: Card(
        margin: const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(
              top: BorderSide(color: colorScheme.outline, width: 1),
              left: BorderSide(color: colorScheme.outline, width: 1),
              right: BorderSide(color: colorScheme.outline, width: 1),
              bottom: BorderSide(color: colorScheme.outline, width: 3),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.headlineLarge!,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bagian Kiri
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/streak.svg', // Path ke gambar
                        width: 20, // Sesuaikan ukuran gambar
                        height: 33,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${ref.watch(userDataProvider.select((data) => data.currentStreak))}',
                      ), // Ganti dengan current streak dari user_data_provider
                      const SizedBox(width: 20),
                      SvgPicture.asset('assets/star/star_active.svg'),
                      const SizedBox(width: 5),
                      Text(
                        '${ref.watch(userDataProvider.select((data) => data.totalStars))}',
                      ),
                    ],
                  ),

                  // Bagian Kanan
                  lessonsAsync.when(
                    loading: () => const Text('0 / 0'),
                    error: (error, stack) => Text('Error'),
                    data:
                        (lessons) => Text(
                          '${ref.watch(userDataProvider.notifier).nextLessonOrder} / ${lessons.length}',
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
