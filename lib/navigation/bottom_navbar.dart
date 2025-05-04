import 'package:flutter/material.dart';
import 'package:adibasa_app/screens/kamus.dart';
import 'package:adibasa_app/screens/level_selection.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int selectedIndex = 0;

  final List<Widget> pages = [LevelSelection(), KamusPage()];

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.primaryContainer,
              width: 2,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: selectedIndex,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: buildNavIcon(context, 0, Icons.home_outlined, 'Beranda'),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: buildNavIcon(context, 1, Icons.menu_book_outlined, 'Kamus'),
              label: '',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavIcon(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final bool isSelected = selectedIndex == index;

    Widget iconWidget = Icon(
      icon,
      color:
          isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.primary,
      size: 24,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        isSelected
            ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 7),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.tertiary,
                    offset: const Offset(0, 3),
                    blurRadius: 0,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: iconWidget,
            )
            : iconWidget,
        const SizedBox(height: 4),
        isSelected
            ? Text(
              label,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w800
              )
            )
            : const SizedBox.shrink(),
      ],
    );
  }
}
