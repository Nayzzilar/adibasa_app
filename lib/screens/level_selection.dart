import 'package:adibasa_app/models/level.dart';
import 'package:adibasa_app/providers/lessons_provider.dart';
import 'package:adibasa_app/providers/user_data_provider.dart';
import 'package:adibasa_app/widgets/level_selection/level_locked.dart';
import 'package:adibasa_app/widgets/level_selection/status_bar_level_selection.dart';
import 'package:flutter/material.dart';
import 'package:adibasa_app/widgets/level_selection/level_unlocked.dart';
import 'package:adibasa_app/models/lesson_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:adibasa_app/navigation/route_name.dart';
import 'package:adibasa_app/providers/lesson_game_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LevelSelection extends ConsumerStatefulWidget {
  const LevelSelection({super.key});

  @override
  ConsumerState<LevelSelection> createState() => _LevelSelectionState();
}

class _LevelSelectionState extends ConsumerState<LevelSelection> {
  int currentMapIndex = 0; // 0: peta_bagian1, 1: peta_bagian2, 2: peta_bagian3
  static const List<int> levelsPerMap = [12, 11, 7]; // Total 30 level: 12, 11, 7

  // Posisi level dengan distribusi yang lebih merata dan tidak overlapping
  final List<List<Offset>> levelPositionsPercent = [
    // peta_bagian1 (12 level) - Distribusi merata di seluruh area peta
    [
      // Row 1 (bottom) - 3 levels
      Offset(0.15, 0.85), // 1 - Bottom left
      Offset(0.50, 0.88), // 2 - Bottom center
      Offset(0.85, 0.85), // 3 - Bottom right
      
      // Row 2 (middle-bottom) - 3 levels
      Offset(0.25, 0.68), // 4 - Left middle-bottom
      Offset(0.60, 0.70), // 5 - Right middle-bottom
      Offset(0.80, 0.65), // 6 - Far right middle-bottom
      
      // Row 3 (center) - 3 levels
      Offset(0.20, 0.50), // 7 - Left center
      Offset(0.50, 0.52), // 8 - Center
      Offset(0.75, 0.48), // 9 - Right center
      
      // Row 4 (top) - 3 levels
      Offset(0.30, 0.32), // 10 - Left top
      Offset(0.55, 0.30), // 11 - Center top
      Offset(0.80, 0.35), // 12 - Right top
    ],
    
    // peta_bagian2 (11 level) - Distribusi zigzag untuk mengisi area kosong
    [
      // Bottom row - 3 levels
      Offset(0.20, 0.82), // 13 - Bottom left
      Offset(0.50, 0.85), // 14 - Bottom center
      Offset(0.80, 0.80), // 15 - Bottom right
      
      // Middle-bottom row - 3 levels
      Offset(0.15, 0.65), // 16 - Left middle-bottom
      Offset(0.45, 0.68), // 17 - Center middle-bottom
      Offset(0.75, 0.63), // 18 - Right middle-bottom
      
      // Center row - 3 levels
      Offset(0.25, 0.48), // 19 - Left center
      Offset(0.60, 0.50), // 20 - Right center
      Offset(0.85, 0.45), // 21 - Far right center
      
      // Top row - 2 levels
      Offset(0.35, 0.30), // 22 - Left top
      Offset(0.70, 0.32), // 23 - Right top
    ],
    
    // peta_bagian3 (7 level) - Distribusi diamond pattern
    [
      // Bottom - 2 levels
      Offset(0.25, 0.78), // 24 - Bottom left
      Offset(0.75, 0.78), // 25 - Bottom right
      
      // Middle - 3 levels
      Offset(0.15, 0.55), // 26 - Left middle
      Offset(0.50, 0.58), // 27 - Center middle
      Offset(0.85, 0.55), // 28 - Right middle
      
      // Top - 2 levels
      Offset(0.35, 0.35), // 29 - Left top
      Offset(0.65, 0.35), // 30 - Right top
    ],
  ];

  final List<String> mapAssets = [
    'assets/images/peta_bagian_1.jpg',
    'assets/images/peta_bagian_2.jpg',
    'assets/images/peta_bagian_3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final lessonsAsync = ref.watch(lessonsProvider);
    final gameState = ref.watch(lessonGameProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: SafeArea(
        child: Column(
          children: [
            // Status bar tetap
            const StatusBarLevelSelection(),
            Expanded(
              child: lessonsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
                data: (lessons) => _buildMapLevels(context, ref, lessons, gameState),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapLevels(BuildContext context, WidgetRef ref, List<Lesson> lessons, LessonGameState gameState) {
    final userData = ref.watch(userDataProvider);
    // Gabungkan data lessons asli dan dummy
    int start = 0;
    for (int i = 0; i < currentMapIndex; i++) {
      start += levelsPerMap[i];
    }
    int end = start + levelsPerMap[currentMapIndex];
    final mapLessonCount = (end - start);
    final positionsPercent = levelPositionsPercent[currentMapIndex].take(mapLessonCount).toList();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height - 180; // kurangi statusbar & bottomnav

    // Buat 30 level: yang ada di lessons pakai data asli, sisanya dummy locked
    List<Level> allLevels = List.generate(30, (i) {
      if (i < lessons.length) {
        final lesson = lessons[i];
        final isFirstLevel = lesson.order == 1 || i == 0;
        final isLocked = !isFirstLevel && !userData.lessonStars.containsKey(lesson.order - 1);
        final stars = userData.lessonStars[lesson.order] ?? 0;
        return Level(
          level: lesson.order,
          name: lesson.title,
          description: lesson.title,
          stars: stars,
          isLocked: isLocked,
        );
      } else {
        // Dummy locked
        return Level(
          level: i + 1,
          name: "Level ${i + 1}",
          description: "",
          stars: 0,
          isLocked: true,
        );
      }
    });
    final levels = allLevels.sublist(start, end);

    return Stack(
      children: [
        // Background peta
        Positioned.fill(
          child: Image.asset(
            mapAssets[currentMapIndex],
            fit: BoxFit.cover,
          ),
        ),
        // Level/lock di posisi
        ...levels.asMap().entries.map((entry) {
          final idx = entry.key;
          final level = entry.value;
          final percent = positionsPercent[idx];
          // Pastikan posisi tidak keluar layar dengan margin yang lebih besar
          final safeX = (percent.dx * (screenWidth - 100)).clamp(50.0, screenWidth - 100);
          final safeY = (percent.dy * (screenHeight - 100)).clamp(50.0, screenHeight - 100);
          final pos = Offset(safeX, safeY);
          return Positioned(
            left: pos.dx,
            top: pos.dy,
            child: _MapLevelCircle(
              level: level,
              onTap: (!level.isLocked && (level.level <= lessons.length)) ? () => _navigateToLesson(ref, lessons[level.level - 1]) : null,
            ),
          );
        }).toList(),
        // Tombol prev
        if (currentMapIndex > 0)
          Positioned(
            left: 16,
            top: MediaQuery.of(context).size.height * 0.4,
            child: _MapNavButton(
              assetPath: 'assets/images/prev_peta.png',
              onTap: () {
                setState(() {
                  currentMapIndex--;
                });
              },
            ),
          ),
        // Tombol next
        if (currentMapIndex < mapAssets.length - 1)
          Positioned(
            right: 16,
            top: MediaQuery.of(context).size.height * 0.4,
            child: _MapNavButton(
              assetPath: 'assets/images/next_peta.png',
              onTap: () {
                setState(() {
                  currentMapIndex++;
                });
              },
            ),
          ),
      ],
    );
  }

  void _navigateToLesson(WidgetRef ref, Lesson lesson) {
    try {
      ref.read(lessonGameProvider.notifier).setLesson(lesson);
      Get.toNamed(RouteName.questions);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.onSecondaryContainer,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '',
        ),
      ],
      currentIndex: 1,
      onTap: (index) {
        // TODO: Implementasi navigasi bottom nav jika diperlukan
      },
    );
  }
}

class _MapLevelCircle extends StatelessWidget {
  final Level level;
  final VoidCallback? onTap;
  const _MapLevelCircle({required this.level, this.onTap});

  @override
  Widget build(BuildContext context) {
    final double size = 60; // Ukuran button level
    final Color buttonColor = level.isLocked 
        ? Colors.white.withOpacity(0.9)
        : const Color(0xFFF2E3C6); // Background untuk level terbuka
    
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Button level dengan desain sesuai prototype
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: buttonColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: level.isLocked
                    ? Colors.grey.shade400
                    : const Color(0xFFC0A77E), // Border untuk level terbuka
                width: 3.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: level.isLocked
                  ? Icon(
                      Icons.lock,
                      color: Colors.grey.shade600,
                      size: 28,
                    )
                  : Text(
                      level.level.toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface, // Foreground color
                      ),
                    ),
            ),
          ),
          // Bintang lebih menempel ke lingkaran (overlap sedikit)
          if (!level.isLocked)
            Transform.translate(
              offset: const Offset(0, -8), // Naikkan bintang agar nempel/overlap
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: SvgPicture.asset(
                    i < level.stars
                        ? 'assets/star/star_active.svg'
                        : 'assets/star/star_inactive.svg',
                    width: 20, // Ukuran star sesuai prototype
                    height: 20,
                  ),
                )),
              ),
            ),
        ],
      ),
    );
  }
}

// Tombol navigasi peta menggunakan asset gambar
class _MapNavButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;
  const _MapNavButton({required this.assetPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        assetPath,
        width: 60, // Sesuaikan ukuran dengan kebutuhan
        height: 60,
      ),
    );
  }
}