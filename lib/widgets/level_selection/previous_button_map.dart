import 'package:adibasa_app/models/level.dart';
import 'package:flutter/material.dart';

class PreviousButtonMap extends StatefulWidget {
  final VoidCallback? onTap;
  const PreviousButtonMap({super.key, this.onTap});

  @override
  State<PreviousButtonMap> createState() => _PreviousButtonMapState();
}

class _PreviousButtonMapState extends State<PreviousButtonMap> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnimation = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.reverse();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.forward();
  }

  void _onTapCancel() {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.tertiary;

    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, bottom: 10),
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        child: Ink(
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: widget.onTap,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) => Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(40),
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
                        Icons.keyboard_double_arrow_left_rounded,
                        size: 38,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
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
