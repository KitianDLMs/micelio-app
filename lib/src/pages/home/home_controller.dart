import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/user.dart';

class HomeController extends GetxController {

  User user = User.fromJson(GetStorage().read('user') ?? {});

  HomeController() {
  }

  void signOut() {
    GetStorage().remove('user');

    Get.offNamedUntil('/home-tutorial', (route) => false); // ELIMINAR EL HISTORIAL DE PANTALLAS
  }

}