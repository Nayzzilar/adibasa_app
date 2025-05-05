import 'package:adibasa_app/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class StatusBarLevelSelection extends ConsumerWidget {
  const StatusBarLevelSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
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
                const Text('Level 3/50'), // Gaya teks otomatis diterapkan
              ],
            ),
          ),
        ),
      ),
    );
  }
}
