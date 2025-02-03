// import 'dart:convert';

// import 'package:get/get.dart';

// import 'package:flutter/material.dart';
// // import 'package:mercado_youtube/screen/pago_screen.dart';
// import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
// import 'package:micelio/src/environment/environment.dart';
// import 'package:micelio/src/pages/client/payments/create/client_payments_create_controller.dart';
// import 'package:micelio/src/pages/client/payments/pays/pago_page.dart';

// class ClientPaymentsCreatePage extends StatelessWidget {
//   const ClientPaymentsCreatePage({super.key});
//   @override
//   Widget build(BuildContext context) {
//     ClientPaymentsCreateController con = Get.put(ClientPaymentsCreateController());

//     return Scaffold(
//       backgroundColor: const Color(0xfffefdfd),
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               const Text(
//                 'MercadoPago',
//                 style: TextStyle(fontSize: 40),
//               ),
//               const SizedBox(
//                 child: Icon(Icons.payments  ),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   print(jsonEncode('PAGE ${con.bag}'));
//                   try {
//                     con.sendPayment(context);                    
//                   } catch (e) {
//                     print('Error en la solicitud: $e');
//                   }
//                 },
//                 child: const Text('Enviar Solicitud'),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
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
// }
