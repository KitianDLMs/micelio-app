import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/response_api.dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/pages/client/home/client_home_page.dart';
import 'package:micelio/src/pages/client/products/detail/client_products_detail_controller.dart';
import 'package:micelio/src/pages/client/trade/trade_home_page.dart';
import 'package:micelio/src/providers/socket_service.dart';
import 'package:micelio/src/providers/users_provider.dart';
import 'package:provider/provider.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  UsersProvider usersProvider = UsersProvider();

  void goToRegisterPage() {
    Get.toNamed('/register');
  }

  void login(context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (isValidForm(email, password)) {
      ResponseApi responseApi = await usersProvider.login(email, password);
      print(responseApi.data);
      if (responseApi.success == true) {
        GetStorage().write('user', responseApi.data);
        User myUser = User.fromJson(GetStorage().read('user') ?? {});

        if (myUser.roles!.length > 1) {
          goToRolesPage();
        } else {
          goToTradesPage();
        }
      } else {
        Get.snackbar('Login fallido', responseApi.message ?? '');
      }
    }
  }

  // void goToClientProductPage() {
  //   Get.offNamedUntil('/client/products/list', (route) => false);
  // }

  void goToTradesPage() {
    Get.off(() => TradeHomePage());
  }

  void goToRolesPage() {
    Get.offNamedUntil('/roles', (route) => false);
  }

  void goToTutorialPage() {
    Get.toNamed('/home-tutorial');
  }

  bool isValidForm(String email, String password) {
    if (email.isEmpty) {
      Get.snackbar('Formulario no valido', 'Debes ingresar el email');
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Formulario no valido', 'El email no es valido');
      return false;
    }

    if (password.isEmpty) {
      Get.snackbar('Formulario no valido', 'Debes ingresar el password');
      return false;
    }

    return true;
  }
}
