import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'package:micelio/src/environment/environment.dart';
import 'package:micelio/src/models/response_api.dart';
import 'package:micelio/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class MercadopagoProvider extends GetConnect {
  String url = '${Environment.API_URL}api/preferences/createPreferences';

  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  final bag = GetStorage().read('shopping_bag');

  Future<Response> create(dynamic bag) async {
    Response response = await post('$url', bag, headers: {
      'Content-Type': 'application/json'
    });
    return response;
  }
}
