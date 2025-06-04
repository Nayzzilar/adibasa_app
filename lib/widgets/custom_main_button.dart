import 'package:flutter/material.dart';
import 'package:adibasa_app/theme/theme.dart';

class CustomMainButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final double? width;
  final double? height;

  const CustomMainButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: CustomColors.buttonColor, width: 2),
          right: BorderSide(color: CustomColors.buttonColor, width: 2),
          bottom: BorderSide(color: CustomColors.buttonColor, width: 4),
          left: BorderSide(color: CustomColors.buttonColor, width: 2),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          minimumSize: Size(width ?? 330, height ?? 48),
          foregroundColor: Colors.white,
          backgroundColor: backgroundColor ?? CustomColors.borderButton,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
