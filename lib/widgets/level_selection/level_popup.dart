import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adibasa_app/models/level.dart';

class LevelPopup extends StatelessWidget {
  final Level level;
  final VoidCallback? onTap;

  const LevelPopup({Key? key, required this.level, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: PopupWithTrianglePainter(
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        child: Container(
          width: 250,
          height: 152, // Increased to accommodate triangle
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28), // Extra bottom padding for triangle
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header with Title
              Text(
                level.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
              Text(
                level.description,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
              const SizedBox(height: 8),

              /// Stars and Start Button in the same row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Left side: Stars
                  Row(
                    children: List.generate(3, (index) {
                      final isActive = level.stars > index;
                      final offset =
                          index == 1 ? const Offset(0, -8) : Offset.zero;

                      return Transform.translate(
                        offset: offset,
                        child: SvgPicture.asset(
                          isActive
                              ? 'assets/star/star_active.svg'
                              : 'assets/star/star_inactive.svg',
                          height: 35,
                          width: 35,
                        ),
                      );
                    }),
                  ),

                  /// Right side: Start button with custom border
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary,
                          width: 1.0,
                        ),
                        left: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary,
                          width: 1.0,
                        ),
                        right: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary,
                          width: 1.0,
                        ),
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary,
                          width: 3.0,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Tutup popup terlebih dahulu

                        // Kemudian navigasi ke soal jika onTap tersedia
                        if (onTap != null) {
                          onTap!();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        // Remove default elevation and border
                        elevation: 10,
                        shadowColor: Colors.transparent,
                        side: BorderSide.none,
                      ),
                      child: Text(
                        'Start',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Additional widgets can go here
            ],
          ),
        ),
      ),
    );
  }
}

class PopupWithTrianglePainter extends CustomPainter {
  final Color backgroundColor;

  PopupWithTrianglePainter({
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create the main path for the popup with triangle
    final path = Path();
    
    // Start from top-left corner with rounded corner
    path.moveTo(6, 0);
    
    // Top edge
    path.lineTo(size.width - 6, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 6);
    
    // Right edge
    path.lineTo(size.width, size.height - 18 - 6);
    path.quadraticBezierTo(size.width, size.height - 18, size.width - 6, size.height - 18);
    
    // Bottom right to triangle start
    path.lineTo(size.width / 2 + 12, size.height - 18);
    
    // Triangle pointer
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width / 2 - 12, size.height - 18);
    
    // Bottom left to corner
    path.lineTo(6, size.height - 18);
    path.quadraticBezierTo(0, size.height - 18, 0, size.height - 18 - 6);
    
    // Left edge
    path.lineTo(0, 6);
    path.quadraticBezierTo(0, 0, 6, 0);
    
    path.close();

    // Fill the shape
    final fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}