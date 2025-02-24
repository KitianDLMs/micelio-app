import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:micelio/src/models/user.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:micelio/src/models/category.dart';
import 'package:micelio/src/models/product.dart';
import 'package:micelio/src/models/response_api.dart';
import 'package:micelio/src/providers/categories_provider.dart';
import 'package:micelio/src/providers/products_provider.dart';

class RestaurantProductsCreateController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  CategoriesProvider categoriesProvider = CategoriesProvider();
  User user = User.fromJson(GetStorage().read('user') ?? {});

  ImagePicker picker = ImagePicker();
  File? imageFile1;
  // File? imageFile2;
  // File? imageFile3;

  var idCategory = ''.obs;
  List<Category> categories = <Category>[].obs;
  ProductsProvider productsProvider = ProductsProvider();

  // RestaurantProductsCreateController() {        
  //   getCategories(trade);
  // }

  void getCategories(String id) async {    
    var result = await categoriesProvider.getAllByTrade(id);
    categories.clear();
    categories.addAll(result);
  }

  void createProduct(BuildContext context) async {
    String name = nameController.text;
    String description = descriptionController.text;
    String price = priceController.text;
    String stock = stockController.text;
    ProgressDialog progressDialog = ProgressDialog(context: context);

    if (isValidForm(name, description, price)) {
      Product product = Product(
          name: name,
          tradeId: user.tradeId,
          description: description,
          price: double.parse(price),
          stock: int.parse(stock),
          idCategory: idCategory.value);
      progressDialog.show(max: 100, msg: 'Espere un momento...');

      List<File> images = [];
      // images.add(imageFile1!);
      // images.add(imageFile2!);
      // images.add(imageFile3!);

      Stream stream = await productsProvider.create(product, images);
      stream.listen((res) {
        progressDialog.close();

        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
        Get.snackbar('Proceso terminado', responseApi.message ?? '');
        if (responseApi.success == true) {
          clearForm();
        }
      });
    }
  }

  bool isValidForm(String name, String description, String price) {
    if (name.isEmpty) {
      Get.snackbar('Fomulario no valido', 'Ingresa el nombre del producto');
      return false;
    }
    if (description.isEmpty) {
      Get.snackbar(
          'Fomulario no valido', 'Ingresa la descripcion del producto');
      return false;
    }
    if (price.isEmpty) {
      Get.snackbar('Fomulario no valido', 'Ingresa el precio del producto');
      return false;
    }
    if (idCategory.value == '') {
      Get.snackbar(
          'Fomulario no valido', 'Debes seleccionar la categoria del producto');
      return false;
    }

    // if (imageFile1 == null) {
    //   Get.snackbar(
    //       'Fomulario no valido', 'Selecciona la imagen numero 1 del producto');
    //   return false;
    // }
    // if (imageFile2 == null) {
    //   Get.snackbar(
    //       'Fomulario no valido', 'Selecciona la imagen numero 2 del producto');
    //   return false;
    // }
    // if (imageFile3 == null) {
    //   Get.snackbar(
    //       'Fomulario no valido', 'Selecciona la imagen numero 3 del producto');
    //   return false;
    // }

    return true;
  }

  Future selectImage(ImageSource imageSource, int numberFile) async {
    XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      if (numberFile == 1) {
        imageFile1 = File(image.path);
      }
      // else if (numberFile == 2) {
      //   imageFile2 = File(image.path);
      // } else if (numberFile == 3) {
      //   imageFile3 = File(image.path);
      // }

      update();
    }
  }

  void showAlertDialog(BuildContext context, int numberFile) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.gallery, numberFile);
        },
        child: Text(
          'GALERIA',
          style: TextStyle(color: Colors.black),
        ));
    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.camera, numberFile);
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

  void clearForm() {
    nameController.text = '';
    descriptionController.text = '';
    priceController.text = '';
    imageFile1 = null;
    // imageFile2 = null;
    // imageFile3 = null;
    idCategory.value = '';
    update();
  }
}
