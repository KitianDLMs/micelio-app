import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/pages/client/home/client_home_page.dart';
import 'package:micelio/src/pages/client/trade/trade_home_page.dart';

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  static Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      final googleKey = await account!.authentication;      
      final signInWithGoogleEndpoint = Uri(
          scheme: 'https',
          host: 'micelio.onrender.com',
          path: '/api/users/google');

      final session = await http
          .post(signInWithGoogleEndpoint, body: {'token': googleKey.idToken});
            
      final decodedJson = json.decode(session.body);
      final user = decodedJson['user'];

      GetStorage().write('user', user);
      User myUser = User.fromJson(GetStorage().read('user') ?? {});            
      if (myUser.id != null) {
        Get.off(() => TradeHomePage());
      } else {
        Get.snackbar('Login fallido', 'error con el Google sign in');
      }
      return account;
    } catch (e) {
      print('Error en google Signin');
      print(e);
      return null;
    }
  }

  static Future signOut() async {
    await _googleSignIn.signOut();
  }
}
