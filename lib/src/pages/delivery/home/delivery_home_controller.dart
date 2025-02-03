import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/providers/push_notifications_provider.dart';

class DeliveryHomeController extends GetxController {

  var indexTab = 0.obs;
  PushNotificationsProvider pushNotificationsProvider = new PushNotificationsProvider();
  User user = User.fromJson(GetStorage().read('user') ?? {});

  DeliveryHomeController() {    
    saveToken();
  }

  void changeTab(int index) {
    indexTab.value = index;
  }

  void saveToken() {
    if (user.id != null) {
      pushNotificationsProvider.saveToken(user.id!);
    }
  }

  void signOut() {
    GetStorage().remove('user');

    Get.offNamedUntil('/', (route) => false); // ELIMINAR EL HISTORIAL DE PANTALLAS
  }



}