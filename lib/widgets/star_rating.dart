import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audioplayers/audioplayers.dart';

class StarRating extends StatefulWidget {
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
  }) : super(key: key);

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _starAnimations;
  final List<AudioPlayer> _audioPlayers = [];
  late List<bool> _soundPlayed;

  @override
  void initState() {
    super.initState();
    // Initialize audio players and sound played flags
    _soundPlayed = List.generate(widget.totalStars, (index) => false);
    for (int i = 0; i < widget.starCount; i++) {
      _audioPlayers.add(AudioPlayer());
    }

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700 * widget.starCount),
    );

    _starAnimations = List.generate(widget.totalStars, (index) {
      final double start = (1.0 / widget.totalStars) * index;
      final double end = (1.0 / widget.totalStars) * (index + 1);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.elasticOut),
        ),
      );
    });

    _controller.addListener(() {
      for (int i = 0; i < widget.starCount; i++) {
        // Check if animation for this star has started and sound hasn't been played
        if (_controller.value >= (1.0 / widget.totalStars) * i &&
            !_soundPlayed[i]) {
          _playSound(i);
          setState(() {
            _soundPlayed[i] = true;
          });
        }
      }
    });

    _controller.forward();
  }

  void _playSound(int starIndex) async {
    if (starIndex >= _audioPlayers.length) return;
    await _audioPlayers[starIndex].play(AssetSource('audio/benar.mp3'));
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var player in _audioPlayers) {
      player.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: widget.alignment,
      children: List.generate(widget.totalStars, (index) {
        final isActive = index < widget.starCount;
        final isMiddle = index == widget.totalStars ~/ 2;

        Widget starContent;
        if (isActive) {
          starContent = ScaleTransition(
            scale: _starAnimations[index],
            child: SvgPicture.asset(
              'assets/star/star_active.svg',
              height: widget.size,
              width: widget.size,
            ),
          );
        } else {
          // Inactive stars appear without animation
          starContent = SvgPicture.asset(
            'assets/star/star_inactive.svg',
            height: widget.size,
            width: widget.size,
          );
        }

        return Padding(
          padding: EdgeInsets.only(
            right: index < widget.totalStars - 1 ? widget.spacing : 0,
          ),
          child: Transform.translate(
            offset:
                isMiddle ? const Offset(0, -10) : Offset.zero, // Naikkan tengah
            child: starContent,
          ),
        );
      }),
    );
  }
}
