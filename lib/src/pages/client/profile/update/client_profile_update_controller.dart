import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:micelio/main.dart';
import 'package:micelio/src/pages/client/home/client_home_page.dart';
import 'package:micelio/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:micelio/src/models/response_api.dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:micelio/src/providers/users_provider.dart';

class ClientProfileUpdateController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});
  // var user = User().obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  ImagePicker picker = ImagePicker();
  File? imageFile;

  UsersProvider usersProvider = UsersProvider();

  ClientProfileInfoController clientProfileInfoController = Get.find();

  ClientProfileUpdateController() {
    // print('USER SESION: ${GetStorage().read('user')}');
    nameController.text = user.name ?? '';
    lastnameController.text = user.lastname ?? '';
    phoneController.text = user.phone ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    // Cargar datos iniciales del usuario desde GetStorage
    Map<String, dynamic> userData = GetStorage().read('user') ?? {};
    user = User.fromJson(userData);
    nameController.text = user.name ?? '';
    lastnameController.text = user.lastname ?? '';
    phoneController.text = user.phone ?? '';
  }

  void updateInfo(BuildContext context) async {
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text;

    if (isValidForm(name, lastname, phone)) {
      ProgressDialog progressDialog = ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Actualizando datos...');

      User myUser = User(
        id: user.id,
        name: name,
        lastname: lastname,
        phone: phone,
        notification_token: user.notification_token,
      );

      if (imageFile == null) {
        ResponseApi responseApi = await usersProvider.update(myUser);

        progressDialog.close();

        if (responseApi.success == true) {
          User updatedUser = User.fromJson(responseApi.data);
          GetStorage().write('user', updatedUser.toJson());

          var storedUser = GetStorage().read('user');

          user = updatedUser;

          Get.snackbar('Proceso terminado', 'Datos actualizados correctamente');
          goToClientProductPage();
        }
      } else {
        // Manejar la actualización con imagen (pendiente)
      }
    }
  }

  void goToClientProductPage() {
    Get.offAll(() => ClientHomePage());
  }

  bool isValidForm(String name, String lastname, String phone) {
    if (name.isEmpty) {
      Get.snackbar('Formulario no valido', 'Debes ingresar tu nombre');
      return false;
    }

    if (lastname.isEmpty) {
      Get.snackbar('Formulario no valido', 'Debes ingresar tu apellido');
      return false;
    }

    if (phone.isEmpty) {
      Get.snackbar(
          'Formulario no valido', 'Debes ingresar tu numero telefonico');
      return false;
    }

    return true;
  }

  Future selectImage(ImageSource imageSource) async {
    XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      imageFile = File(image.path);
      update();
    }
  }

  void showAlertDialog(BuildContext context) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.gallery);
        },
        child: Text(
          'GALERIA',
          style: TextStyle(color: Colors.black),
        ));
    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.camera);
        },
        child: Text(
          'CAMARA',
          style: TextStyle(color: Colors.black),
        ));

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona una opcion'),
      actions: [galleryButton, cameraButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
