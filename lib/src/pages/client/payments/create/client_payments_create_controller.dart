// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_credit_card/credit_card_model.dart';
// import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:micelio/src/models/mercado_pago_card_token.dart';
// import 'package:micelio/src/models/mercado_pago_document_type.dart';
// import 'package:micelio/src/pages/client/payments/pays/pago_page.dart';
// import 'package:micelio/src/providers/mercado_pago_provider.dart';
// import 'package:micelio/src/providers/mercadopago_provider.dart';
// import 'package:micelio/src/providers/users_provider.dart';

// class ClientPaymentsCreateController extends GetxController {
//   TextEditingController documentNumberController = TextEditingController();

//   var cardNumber = ''.obs;
//   var expireDate = ''.obs;
//   var cardHolderName = ''.obs;
//   var cvvCode = ''.obs;
//   var isCvvFocused = false.obs;
//   var idDocument = ''.obs;
//   GlobalKey<FormState> keyForm = GlobalKey();

//   MercadoPagoProvider mercadoPagoProvider = MercadoPagoProvider();
//   MercadopagoProvider mercadopagoProvider = MercadopagoProvider();
//   List<MercadoPagoDocumentType> documents = <MercadoPagoDocumentType>[].obs;

//   final bag = GetStorage().read('shopping_bag');

//   ClientPaymentsCreateController() {
//     parseBag();
//   }

//   Map<String, dynamic> parseBag() {
//     if (bag != null && bag is List) {
//       List<Map<String, dynamic>> parsedItems = [];
//       for (var item in bag) {
//         if (item is Map<String, dynamic>) {
//           parsedItems.add({
//             'title': item['name'] ?? 'Producto sin nombre',
//             'quantity': item['quantity'] ?? 1,
//             'unit_price': (item['price'] as num?)?.toDouble() ?? 0.0,
//             'currency_id': 'CLP',
//           });
//         }
//       }
//       // print('method $bag');
//       return {'items': parsedItems};
//     }
//     return {'items': []};
//   }

//   void sendPayment(context) async {
//     Response response = await mercadopagoProvider.create(bag);
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> res = response.body;
//       _launchURL(context, res['url']);
//       // if (context.mounted) {
//       //   Navigator.pushReplacement(
//       //       context,
//       //       MaterialPageRoute(
//       //           builder: (BuildContext context) => PagoPage(
//       //                 url: res["url"],
//       //               )));
//       // }
//     } else {
//       print('Error: ${response.statusCode}');
//     }
//   }

//   void _launchURL(BuildContext context, dynamic url) async {
//     final theme = Theme.of(context);
//     try {
//       await launchUrl(
//         Uri.parse('$url'),
//         customTabsOptions: CustomTabsOptions(
//           colorSchemes: CustomTabsColorSchemes.defaults(
//             toolbarColor: theme.colorScheme.surface,
//           ),
//           shareState: CustomTabsShareState.on,
//           urlBarHidingEnabled: true,
//           showTitle: true,
//           closeButton: CustomTabsCloseButton(
//             icon: CustomTabsCloseButtonIcons.back,
//           ),
//         ),
//         safariVCOptions: SafariViewControllerOptions(
//           preferredBarTintColor: theme.colorScheme.surface,
//           preferredControlTintColor: theme.colorScheme.onSurface,
//           barCollapsingEnabled: true,
//           dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
//         ),
//       );
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }
//   double calculateTotal() {
//     double total = 0.0;
//     if (bag != null && bag is List) {
//       for (var item in bag) {
//         if (item is Map<String, dynamic> &&
//             item.containsKey('price') &&
//             item.containsKey('quantity')) {
//           double price = (item['price'] as num).toDouble();
//           int quantity = (item['quantity'] as num).toInt();
//           total += price * quantity;
//         }
//       }
//     }
//     return total;
//   }
// }
