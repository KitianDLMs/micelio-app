import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/response_api.dart';
import 'package:micelio/src/models/trade..dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/providers/trade_provider.dart';

class RestaurantTradeCreateController extends GetxController {
  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();

  TradeProvider tradeProvider = TradeProvider();

  void createTrade() async {  
    String name = nameController.text;
    String description = descriptionController.text;
    String url = imageUrlController.text;

    if (name.isNotEmpty && description.isNotEmpty) {
      Trade trade = Trade(name: name, description: description, userId: userSession.id, image: url);

      ResponseApi responseApi = await tradeProvider.create(trade);
      Get.snackbar('Proceso terminado', responseApi.message ?? '');

      if (responseApi.success == true) {
        clearForm();
      }
    } else {
      Get.snackbar('Formulario no valido',
          'Ingresa todos los campos para crear el comercio');
    }
  }

  void clearForm() {
    nameController.text = '';
    descriptionController.text = '';
  }
}
