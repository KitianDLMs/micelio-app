import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/user.dart';

class ClientHomeController extends GetxController {  
  var indexTab = 0.obs;
  User user = User.fromJson(GetStorage().read('user') ?? {});

  ClientHomeController() {}

  void changeTab(int index) {
    indexTab.value = index;
  }

  void signOut() {
    GetStorage().remove('user');
    Get.offNamedUntil(
        '/home-tutorial', (route) => false);
  }

  void goToTrade() { 
    GetStorage().remove('trade');
    Get.offNamedUntil('/trade', (route) => false);
  }
}
