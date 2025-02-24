import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/address.dart';
import 'package:micelio/src/models/response_api.dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:micelio/src/providers/address_provider.dart';

class ClientAddressCreateController extends GetxController {
  TextEditingController addressController = TextEditingController();
  TextEditingController neighborhoodController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  var neighborhoods = [].obs;
  var streets = [].obs;
  var selectedNeighborhood = ''.obs;
  var selectedStreet = ''.obs;
  var numeros = [].obs;
  var selectedNumero = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadNeighborhoods();
  }

  double latRefPoint = 0;
  double lngRefPoint = 0;

  User user = User.fromJson(GetStorage().read('user') ?? {});

  AddressProvider addressProvider = AddressProvider();

  ClientAddressListController clientAddressListController = Get.find();

  void openGoogleMaps(BuildContext context) async {
    // Map<String, dynamic> refPointMap = await showMaterialModalBottomSheet(
    //     context: context,
    //     builder: (context) => ClientAddressMapPage(),
    //     isDismissible: false,
    //     enableDrag: false);

    // print('REF POINT MAP ${refPointMap}');
    // refPointController.text = refPointMap['address'];
    // latRefPoint = refPointMap['lat'];
    // lngRefPoint = refPointMap['lng'];
  }

  Future<void> loadNeighborhoods() async {
    String jsonString =
        await rootBundle.loadString('assets/neighborhoods.json');
    Map<String, dynamic> data = jsonDecode(jsonString);
    neighborhoods.value = data['neighborhoods'];
  }

  void onNeighborhoodSelected(String? value) {
    selectedNeighborhood.value = value!;
    neighborhoodController.text = value;
    streets.value = neighborhoods
        .firstWhere((neighborhood) => neighborhood['name'] == value)['streets'];
    numeros.value = neighborhoods
        .firstWhere((neighborhood) => neighborhood['name'] == value)['numero'];
    selectedStreet.value = '';
    selectedNumero.value = '';
  }

  void onStreetSelected(String? value) {
    selectedStreet.value = value!;
  }

  void onNumberSelected(String? value) {
    selectedNumero.value = value!;
    numberController.text = value; // Actualizar el campo de texto
  }

  void createAddress() async {
    String addressName = selectedStreet.value;
    String neighborhood = neighborhoodController.text;
    String numero = numberController.text;
    if (isValidForm(addressName, neighborhood)) {
      Address address = Address(
          address: addressName,
          neighborhood: neighborhood,
          number: selectedNumero.value,
          idUser: user.id);

      ResponseApi responseApi = await addressProvider.create(address);
      print('responseApi -> $responseApi');
      Fluttertoast.showToast(
          msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);

      if (responseApi.success == true) {
        address.id = responseApi.data;
        GetStorage().write('address', address.toJson());

        clientAddressListController.update();

        Get.back();
      }
    }
  }

  bool isValidForm(String address, String neighborhood) {
    if (address.isEmpty) {
      Get.snackbar('Formulario no valido', 'Ingresa el nombre de la direccion');
      return false;
    }
    if (neighborhood.isEmpty) {
      Get.snackbar('Formulario no valido', 'Ingresa el nombre del barrio');
      return false;
    }
    // if (latRefPoint == 0) {
    //   Get.snackbar('Formulario no valido', 'Selecciona el punto de referencia');
    //   return false;
    // }
    // if (lngRefPoint == 0) {
    //   Get.snackbar('Formulario no valido', 'Selecciona el punto de referencia');
    //   return false;
    // }

    return true;
  }
}
