// lib/widgets/custom_main_button.dart
import 'package:adibasa_app/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:adibasa_app/theme/theme.dart';

class CustomMainButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final double? buttonWidth;
  final double? buttonHeight;

  const CustomMainButton({
    Key? key,
    required this.label,
    this.onPressed,
    required this.variant,
    this.buttonWidth,
    this.buttonHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final feedbackColors = theme.extension<FeedbackColors>()!;
    final bool isDisabled = onPressed == null;

    Color currentBackgroundColor;
    Color currentBorderColor;
    Color currentBorderShadowColor;
    Color currentTextColor;

    switch (variant) {
      case ButtonVariant.primary:
        if (isDisabled) {
          currentBackgroundColor = colorScheme.surface;
          currentBorderColor = colorScheme.outline;
          currentTextColor = colorScheme.onSurface.withOpacity(0.6);
        } else {
          currentBackgroundColor =
              CustomColors.borderButton; // Default active bg from your theme
          currentBorderColor =
              CustomColors.buttonColor; // Default active border
          currentTextColor = Colors.white;
        }
        currentBorderShadowColor = currentBorderColor;
        break;
      case ButtonVariant.periksa:
        if (isDisabled) {
          currentBackgroundColor = colorScheme.surface;
          currentBorderColor = colorScheme.outline;
          currentTextColor = colorScheme.onSurface.withOpacity(0.6);
        } else {
          currentBackgroundColor = colorScheme.tertiaryContainer;
          currentBorderColor = colorScheme.tertiary;
          currentTextColor = Colors.white; // Or colorScheme.onPrimary
        }
        currentBorderShadowColor = currentBorderColor;
        break;
      case ButtonVariant.success:
        if (isDisabled) {
          // Consistent disabled look: greyed out
          currentBackgroundColor = colorScheme.surface.withOpacity(0.5);
          currentBorderColor = colorScheme.outline.withOpacity(0.5);
          currentTextColor = colorScheme.onSurface.withOpacity(0.4);
        } else {
          currentBackgroundColor = feedbackColors.correctButton;
          currentBorderColor =
              feedbackColors.correctButton; // Use the same for a solid look
          currentTextColor = Colors.white;
        }
        currentBorderShadowColor = currentBorderColor; // Shadow matches border
        break;
      case ButtonVariant.danger:
        if (isDisabled) {
          // Consistent disabled look: greyed out
          currentBackgroundColor = colorScheme.surface.withOpacity(0.5);
          currentBorderColor = colorScheme.outline.withOpacity(0.5);
          currentTextColor = colorScheme.onSurface.withOpacity(0.4);
        } else {
          currentBackgroundColor = feedbackColors.wrongButton;
          currentBorderColor =
              feedbackColors.wrongButton; // Use the same for a solid look
          currentTextColor = Colors.white;
        }
        currentBorderShadowColor = currentBorderColor; // Shadow matches border
        break;
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: currentBorderColor, width: 2),
          left: BorderSide(color: currentBorderColor, width: 2),
          right: BorderSide(color: currentBorderColor, width: 2),
          bottom: BorderSide(color: currentBorderShadowColor, width: 4),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.only(top: 2),
          minimumSize: Size(buttonWidth ?? 330, buttonHeight ?? 48),
          backgroundColor: currentBackgroundColor,
          foregroundColor: currentTextColor,
          // ElevatedButton handles visual disabling, but our explicit colors make it clearer
          disabledBackgroundColor:
              currentBackgroundColor, // Use the calculated disabled color
          disabledForegroundColor:
              currentTextColor, // Use the calculated disabled color
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
