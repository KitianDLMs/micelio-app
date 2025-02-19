import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/user.dart';

class ClientHomeController extends GetxController {
  var indexTab = 0.obs;
  User user = User.fromJson(GetStorage().read('user') ?? {});

  ClientHomeController() {
    saveToken();
  }

  void changeTab(int index) {
    indexTab.value = index;
  }

  void saveToken() {
    if (user.id != null) {
    }
  }

  void signOut() {
    GetStorage().remove('user');

    Get.offNamedUntil(
        '/', (route) => false);
  }
}
