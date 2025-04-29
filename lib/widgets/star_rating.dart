import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StarRating extends StatelessWidget {
  final int starCount; // Jumlah bintang yang aktif (1-3)
  final int totalStars; // Total jumlah bintang (default 3)
  final double size; // Ukuran bintang
  final double spacing; // Jarak antar bintang
  final MainAxisAlignment alignment; // Perataan bintang

  const StarRating({
    Key? key,
    required this.starCount,
    this.totalStars = 3,
    this.size = 30.0,
    this.spacing = 8.0,
    this.alignment = MainAxisAlignment.center,
  }) : assert(starCount >= 0 && starCount <= totalStars),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignment,
      children: List.generate(totalStars, (index) {
        // Tampilkan bintang aktif jika index < starCount
        final isActive = index < starCount;
        return Padding(
          padding: EdgeInsets.only(right: index < totalStars - 1 ? spacing : 0),
          child: SvgPicture.asset(
            isActive
                ? 'assets/star/star_active.svg'
                : 'assets/star/star_inactive.svg',
            height: size,
            width: size,
          ),
        );
      }),
    );
  }
}