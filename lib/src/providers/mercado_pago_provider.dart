import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/environment/environment.dart';
import 'package:micelio/src/models/mercado_pago_card_token.dart';
import 'package:micelio/src/models/mercado_pago_document_type.dart';
import 'package:micelio/src/models/mercado_pago_payment_method_installments.dart';
import 'package:micelio/src/models/order.dart';
import 'package:micelio/src/models/response_api.dart';
import 'package:micelio/src/models/user.dart';

class MercadoPagoProvider extends GetConnect {
  String url = Environment.API_MERCADO_PAGO;
  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<List<MercadoPagoDocumentType>> getDocumentsType() async {
    Response response = await get(
      '$url/identification_types',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Environment.ACCESS_TOKEN}'
      },
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada',
          'Tu usuario no tiene permitido leer esta informacion');
      return [];
    }

    List<MercadoPagoDocumentType> documents =
        MercadoPagoDocumentType.fromJsonList(response.body);

    return documents;
  }

  Future<MercadoPagoPaymentMethodInstallments> getInstallments(
      String bin, double amount) async {
    Response response =
        await get('$url/payment_methods/installments', headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Environment.ACCESS_TOKEN}'
    }, query: {
      'bin': bin,
      'amount': '${amount}'
    }); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada',
          'Tu usuario no tiene permitido leer esta informacion');
      return MercadoPagoPaymentMethodInstallments();
    }

    if (response.statusCode != 200) {
      Get.snackbar('Error', 'No se pudo obtener las coutas de la tarjeta');
      return MercadoPagoPaymentMethodInstallments();
    }

    MercadoPagoPaymentMethodInstallments data =
        MercadoPagoPaymentMethodInstallments.fromJson(response.body[0]);

    return data;
  }

  Future<ResponseApi> createPayment({
    @required String? token,
    @required String? paymentMethodId,
    @required String? paymentTypeId,
    @required String? emailCustomer,
    @required String? issuerId,
    @required String? identificationType,
    @required String? identificationNumber,
    @required double? transactionAmount,
    @required int? installments,
    @required Order? order,
  }) async {
    Response response = await post(
      '${Environment.API_URL}api/payments/create',
      {
        'token': token,
        'issuer_id': issuerId,
        'payment_method_id': paymentMethodId,
        'transaction_amount': transactionAmount,
        'installments': installments,
        'payer': {
          'email': emailCustomer,
          'identification': {
            'type': identificationType,
            'number': identificationNumber
          },
        },
        'order': order!.toJson()
      },
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': userSession.sessionToken ?? ''
      },
    );

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

  Future<MercadoPagoCardToken> createCardToken({
    String? cvv,
    String? expirationYear,
    int? expirationMonth,
    String? cardNumber,
    String? cardHolderName,
    String? documentNumber,
    String? documentId,
  }) async {
    Response response = await post(
      'https://api.mercadopago.com/v1/card_tokens?public_key=APP_USR-0bb65c12-44bc-4d0f-99a6-a646891f7175',
      {
        'security_code': cvv,
        'expiration_year': expirationYear,
        'expiration_month': expirationMonth,
        'card_number': cardNumber,
        'cardholder': {
          'name': cardHolderName,
          'identification': {'number': documentNumber, 'type': documentId}
        },
      },
      headers: {
        'Content-Type': 'application/json',
      },
    ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

    if (response.statusCode != 201) {
      Get.snackbar('Error', 'No se pudo validar la tarjeta');
      return MercadoPagoCardToken();
    }

    MercadoPagoCardToken res = MercadoPagoCardToken.fromJson(response.body);

    return res;
  }
}
