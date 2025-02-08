import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/environment/environment.dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/pages/client/home/client_home_page.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;

class AppleSignInService {
  static String clientId = 'com.echnelapp.signin';
  static String redirectUri =
      Environment.redirectUrlApple;

  static void signIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
              clientId: clientId, redirectUri: Uri.parse(redirectUri)));

      final signInWithAppleEndpoint = Uri(
          scheme: 'https',
          host: 'micelio.onrender.com',
          path: '/sign_in_with_apple',
          queryParameters: {
            'code': credential.authorizationCode,
            'firstName': credential.givenName,
            'lastName': credential.familyName,
            'useBundleId': Platform.isIOS ? 'true' : 'false',
            if (credential.state != null) 'state': credential.state
          });

      final session = await http.post(signInWithAppleEndpoint);

      if (session.statusCode == 200) {
        final response = jsonDecode(session.body);
        if (response['ok'] == true) {
          final user = response['user'];
          GetStorage().write('user', user);
          User myUser = User.fromJson(GetStorage().read('user') ?? {});
          if (myUser.id != null) {
            Get.off(() => ClientHomePage());
          } else {
            Get.snackbar('Login fallido', 'error con Apple sign in');
          }
        } else {
          Get.snackbar('Login fallido', response['msg'] ?? 'Error desconocido');
        }
      } else {
        Get.snackbar('Login fallido', 'Error en el servicio');
      }
    } catch (e) {
      print('$e');
    }
  }
}
