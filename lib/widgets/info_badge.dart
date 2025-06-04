// lib/widgets/badge.dart
import 'package:flutter/material.dart';

class InfoBadge extends StatelessWidget {
  final String value;
  final double?
  fontSize; // Optional: if you want to override the default calculation
  final EdgeInsetsGeometry padding;

  const InfoBadge({
    Key? key,
    required this.value,
    this.fontSize,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 4,
    ), // Default padding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final calculatedFontSize = screenWidth * 0.045;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(
          100,
        ), // Rounded corners for a badge look
      ),
      child: Text(
        value,
        style: TextStyle(
          fontSize: fontSize ?? calculatedFontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Text color is white
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
