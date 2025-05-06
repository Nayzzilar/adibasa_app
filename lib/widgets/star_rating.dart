import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StarRating extends StatelessWidget {
  final int starCount;
  final int totalStars;
  final double size;
  final double spacing;
  final MainAxisAlignment alignment;

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
        final isActive = index < starCount;
        final isMiddle = index == totalStars ~/ 2;

        return Padding(
          padding: EdgeInsets.only(right: index < totalStars - 1 ? spacing : 0),
          child: Transform.translate(
            offset: isMiddle ? const Offset(0, -10) : Offset.zero, // Naikkan tengah
            child: SvgPicture.asset(
              isActive
                  ? 'assets/star/star_active.svg'
                  : 'assets/star/star_inactive.svg',
              height: size,
              width: size,
            ),
          ),
        );
      }),
    );
  }
}
