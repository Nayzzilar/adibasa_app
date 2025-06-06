import 'package:adibasa_app/theme/theme.dart';
import 'package:adibasa_app/utils/enums.dart';
import 'package:adibasa_app/widgets/custom_main_button.dart';
import 'package:flutter/material.dart';

class ExitDialog extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onExit;

  const ExitDialog({Key? key, required this.onContinue, required this.onExit})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;

    final feedbackColors = theme.extension<FeedbackColors>();

    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: const Color(0xFFF6E7C1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/InginKeluar.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Apakah Anda yakin ingin keluar?',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorTheme.primary,
                          fontSize: 20,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: CustomMainButton(
                    label: 'Lanjutkan',
                    onPressed: onContinue,
                    variant:
                        ButtonVariant
                            .success, // Using success for positive continuation
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: CustomMainButton(
                    label: 'Keluar',
                    onPressed: onExit,
                    variant: ButtonVariant.danger,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
