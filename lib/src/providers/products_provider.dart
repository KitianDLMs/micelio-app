import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/environment/environment.dart';
import 'package:micelio/src/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:micelio/src/models/response_api.dart';
import 'package:micelio/src/models/user.dart';
import 'package:path/path.dart';

class ProductsProvider extends GetConnect {
  String url = Environment.API_URL + 'api/products';

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<List<Product>> findByCategory(String idCategory) async {
    
    Response response = await get('$url/findByCategory/$idCategory', headers: {
      'Content-Type': 'application/json',
      // 'Authorization': userSession.sessionToken ?? ''
    }); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA
    
    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada',
          'Tu usuario no tiene permitido leer esta informacion');
      return [];
    }

    List<Product> products = Product.fromJsonList(response.body['data']);

    return products;
  }

  Future<List<Product>> findByNameAndCategory(
      String idCategory, String name) async {
        print('userSession.token ${userSession.token}');
    Response response =
        await get('$url/findByNameAndCategory/$idCategory/$name', headers: {
      'Content-Type': 'application/json',
      // 'Authorization': userSession.token ?? ''
    }); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada',
          'Tu usuario no tiene permitido leer esta informacion');
      return [];
    }

    List<Product> products = Product.fromJsonList(response.body);

    return products;
  }
  
  Future<Stream> create(Product product, List<File> images) async {
    Uri uri = Uri.parse('${Environment.API_URL}api/products/create');
    // Uri uri =
    //     Uri.parse('https://echnelapp-delivery.fly.devapi/products/create');
    final request = http.MultipartRequest('POST', uri);
    // request.headers['Authorization'] = userSession.sessionToken ?? '';

    for (int i = 0; i < images.length; i++) {
      request.files.add(http.MultipartFile(
          'image',
          http.ByteStream(images[i].openRead().cast()),
          await images[i].length(),
          filename: basename(images[i].path)));
    }
    request.fields['product'] = json.encode(product);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  Future<ResponseApi> update(Product product) async {
    Response response =
        await put('$url/update/${product.id}', product.toJson(), headers: {
      'Content-Type': 'application/json',
      // 'Authorization': userSession.sessionToken ?? ''
    }); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA
    print(response.body);
    if (response.body == null) {
      Get.snackbar('Error', 'No se pudo actualizar la informacion');
      return ResponseApi();
    }

    if (response.statusCode == 401) {
      Get.snackbar('Error', 'No estas autorizado para realizar esta peticion');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body['data']);

    return responseApi;
  }
}
