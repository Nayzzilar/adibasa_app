import 'package:adibasa_app/models/level.dart';
import 'package:flutter/material.dart';

class NextButtonMap extends StatelessWidget {
  final VoidCallback? onTap;
  const NextButtonMap({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.tertiary;

    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, bottom: 10),
      child: Material(
        color: Colors.transparent,
        elevation:
            0, // Hilangkan elevation karena kita menggunakan border custom
        child: Ink(
          child: InkWell(
            borderRadius: BorderRadius.circular(40),
            splashColor: Theme.of(context).colorScheme.tertiary,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Lingkaran medali dengan angka level di tengah
                Container(
                  width: 50,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    border: Border(
                      top: BorderSide(color: borderColor, width: 2),
                      left: BorderSide(color: borderColor, width: 2),
                      right: BorderSide(color: borderColor, width: 2),
                      bottom: BorderSide(color: borderColor, width: 6),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons
                          .keyboard_double_arrow_right_rounded, // Use the lock icon from Flutter's material icons
                      size: 30,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
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
