import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/environment/environment.dart';
import 'package:micelio/src/models/category.dart';
import 'package:micelio/src/models/order.dart';
import 'package:micelio/src/models/response_api.dart';
import 'package:micelio/src/models/user.dart';

class OrdersProvider extends GetConnect {
  String url = Environment.API_URL + 'api/orders';

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<List<Order>> findByStatus(String status) async {
    Response response = await get('$url/findByStatus/$status', headers: {
      'Content-Type': 'application/json',
      // 'Authorization': userSession.sessionToken ?? ''
    });

    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada',
          'Tu usuario no tiene permitido leer esta informacion');
      return [];
    }

    if (response.status.isOk) {
      List<dynamic> data = response.body['data'];

      List<Order> orders = Order.fromJsonList(data);

      return orders;
    }

    return [];
  }

  Future<List<Order>> findByDeliveryAndStatus(
      String idDelivery, String status) async { 
    Response response =
        await get('$url/findByDeliveryAndStatus/$idDelivery/$status', headers: {
      'Content-Type': 'application/json',
      // 'Authorization': userSession.sessionToken ?? ''
    });    
    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada',
          'Tu usuario no tiene permitido leer esta informacion');
      return [];
    }    
    List<Order> orders = Order.fromJsonList(response.body['data']);

    return orders;
  }

  Future<List<Order>> findByClientAndStatus(
      String idClient, String status) async {
    String newUrl = '$url/findByClientAndStatus/$idClient/$status';
    Response response =
        await get('$url/findByClientAndStatus/$idClient/$status', headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada',
          'Tu usuario no tiene permitido leer esta informacion');
      return [];
    }
    List<Order> orders = Order.fromJsonList(response.body['data']);

    return orders;
  }

  Future<ResponseApi> create(Order order) async {
    Response response = await post('$url/create', order.toJson(), headers: {
      'Content-Type': 'application/json',
      // 'Authorization': userSession.sessionToken ?? ''
    });
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<ResponseApi> updateToDispatched(Order order) async {
    Response response =
        await put('$url/updateToDispatched', order.toJson(), headers: {
      'Content-Type': 'application/json',
    });
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<ResponseApi> updateToOnTheWay(Order order) async {
    Response response =
        await put('$url/updateToOnTheWay', order.toJson(), headers: {
      'Content-Type': 'application/json',
    });

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

  Future<ResponseApi> updateToDelivered(Order order) async {
    Response response =
        await put('$url/updateToDelivered', order.toJson(), headers: {
      'Content-Type': 'application/json',
      // 'Authorization': userSession.sessionToken ?? ''
    }); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

  Future<ResponseApi> updateLatLng(Order order) async {
    Response response =
        await put('$url/updateLatLng', order.toJson(), headers: {
      'Content-Type': 'application/json',
      // 'Authorization': userSession.sessionToken ?? ''
    }); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }
}
