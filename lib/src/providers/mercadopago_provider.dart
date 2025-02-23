import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:micelio/src/environment/environment.dart';
import 'package:micelio/src/models/user.dart';

class MercadopagoProvider extends GetConnect {
  String url = '${Environment.API_URL}api/preferences/createPreferences';

  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  final bag = GetStorage().read('shopping_bag');
  final trade = GetStorage().read('trade');

  Future<Response> create(dynamic bag) async {
    Response response = await post('$url', bag, headers: {      
      'Content-Type': 'application/json'
    });
    return response;
  }
}
