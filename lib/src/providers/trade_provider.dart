import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/environment/environment.dart';
import 'package:micelio/src/models/response_api.dart';
import 'package:micelio/src/models/trade..dart';
import 'package:micelio/src/models/user.dart';

class TradeProvider extends GetConnect {
  String url = Environment.API_URL + 'api/trade';

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<List<Trade>> getAll() async {
    Response response = await get(url, headers: {
      'Content-Type': 'application/json',
      // 'Authorization': userSession.sessionToken ?? ''
    }); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA
    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada',
          'Tu usuario no tiene permitido leer esta informacion');
      return [];
    }

    List<Trade> trade = Trade.fromJsonList(response.body);

    return trade;
  }

  Future<Trade> getById(String id) async {
    Response response = await get('$url/$id', headers: {
      'Content-Type': 'application/json',
      // 'Authorization': userSession.sessionToken ?? ''
    });

    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada',
          'Tu usuario no tiene permitido leer esta informacion');
    }
    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap = response.body;
      Trade trade = Trade.fromJson(responseMap);
      return trade;
    } else {
      throw Exception('Error al obtener el trade: ${response.statusCode}');
    }
  }

  Future<ResponseApi> create(Trade trade) async {
    Response response = await post('$url/create', trade.toJson(), headers: {
      'Content-Type': 'application/json',
      // 'Authorization': userSession.sessionToken ?? ''
    }); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA
    print(response.body);
    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

  Future<ResponseApi> update(Map<String, dynamic> data, String id) async {
    try {
      Response response = await put(
        '$url/update/$id',
        data,
        headers: {
          "Content-Type": "application/json"
        }, // Asegurar que se envía JSON
      );
      print(response.body);
      ResponseApi responseApi = ResponseApi.fromJson(response.body);
      return responseApi;
    } catch (e) {
      print('Error al actualizar trade: $e');
      return ResponseApi(success: false, message: 'Error en la actualización');
    }
  }

  deleteOrders(id) async {    
    Response response = await delete('$url/delete/$id', headers: {      
      'Content-Type': 'application/json',
      // 'Authorization': userSession.sessionToken ?? ''
    });        
    if (response.status.code == 201) {      
      Get.offAllNamed(
                      '/home-tutorial');
    }
    return response;
  }
}
