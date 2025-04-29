import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bottom_navbar_controller.dart';

class BottomNavbar extends StatelessWidget {
  BottomNavbar({super.key});

  final BottomNavbarController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 1)),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFFF2E2C4),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changePage,
          items: [
            BottomNavigationBarItem(
              icon: buildNavIcon(
                0,
                'assets/images/beranda.png',
                'assets/images/beranda_selected.png',
                'Beranda',
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: buildNavIcon(
                1,
                'assets/images/kamus.png',
                'assets/images/kamus_selected.png',
                'Kamus',
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavIcon(
    int index,
    String icon,
    String selectedIcon,
    String label,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: controller.selectedIndex.value == index ? 65 : 30,
          height: controller.selectedIndex.value == index ? 30 : 30,
          child: Image.asset(
            controller.selectedIndex.value == index ? selectedIcon : icon,
          ),
        ),
        const SizedBox(height: 2),
        if (controller.selectedIndex.value == index)
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xff462f00)),
          ),
      ],
    );
  }
}
