import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/providers/push_notifications_provider.dart';

class DeliveryHomeController extends GetxController {

  var indexTab = 0.obs;
  User user = User.fromJson(GetStorage().read('user') ?? {});

  DeliveryHomeController() {    
  }

  void changeTab(int index) {
    indexTab.value = index;
  }

  void signOut() {
    GetStorage().remove('user');

    Get.offNamedUntil('/', (route) => false); // ELIMINAR EL HISTORIAL DE PANTALLAS
  }



}