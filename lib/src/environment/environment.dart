import 'dart:io';

class Environment {

  // static String API_URL  = Platform.isAndroid ? "http://192.168.0.103:3000/" : 'http://192.168.0.103:3000/'; 
  static const String API_URL  = "https://micelio.onrender.com/"; 
  // static String API_URL_OLD  = Platform.isAndroid ? "192.168.0.103:3000" : 'http://192.168.0.103:3000/';
  static const String API_URL_OLD  = "https://micelio.onrender.com/";

  static const String API_MERCADO_PAGO = "https://api.mercadopago.com/v1";
  static const String API_KEY_MAPS = "AIzaSyCPVWrjU7ilkgyNAGbQMzYbh2FWDbc7vYk";

  static const String ACCESS_TOKEN =
      // "TEST-7543954477442042-103010-6f46675043d2151dce61b8b557f01d41-122925330";
      "APP_USR-7543954477442042-103010-8a3abb3bc227c5a4b6156dd5b38ed35a-122925330";
  static const String PUBLIC_KEY =
      // "TEST-84e01b50-cd17-40fb-aefe-e10ba3f8fdbb";
      "APP_USR-0bb65c12-44bc-4d0f-99a6-a646891f7175";
      
  static String socketUrl = 'https://micelio.onrender.com/';
  // static String socketUrl = Platform.isAndroid ? 'http://192.168.0.103:3000/' : 'http://localhost:3000/';  

  static String redirectUrlApple = 'https://micelio.onrender.com/callbacks/sign_in_with_apple';

  static String termsApp = 'https://micelio-terms.netlify.app/';
}