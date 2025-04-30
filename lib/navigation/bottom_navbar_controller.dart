import 'package:get/get.dart';

class BottomNavbarController extends GetxController {
  var selectedIndex = 0.obs;

  void changePage(int index) {
    selectedIndex.value = index;
    switch (index) {
      case 0:
        Get.offAllNamed('/level_selection');
        break;
      case 1:
        Get.offAllNamed('/kamus');
        break;
    }
  }
}
