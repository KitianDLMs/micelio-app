import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:micelio/src/pages/client/payments/pays/pendiente_page%20.dart';
import 'package:micelio/src/pages/client/payments/pays/aprobado_page.dart';
import 'package:micelio/src/pages/client/payments/pays/rechazado_page.dart';
// import 'package:mercado_youtube/screen/aprobado_screen.dart';
// import 'package:mercado_youtube/screen/pendiente_screen.dart';
// import 'package:mercado_youtube/screen/rechazado_screen.dart';

class PagoPage extends StatefulWidget {
  static const String routename = 'PagoPage';
  final String? url;
  const PagoPage({key, this.url});

  @override
  State<PagoPage> createState() => _PagoPageState();
}

class _PagoPageState extends State<PagoPage> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          // InAppWebView(
          //     key: webViewKey,
          //  // initialUrlRequest: URLRequest(url: Uri.parse("${widget.url}")),
          //     initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse("${widget.url}")),),
          //     onUpdateVisitedHistory: (controller, url, androidIsReload) {
          //       print(url);
          //       if (url
          //           .toString()
          //           .contains("https://www.echnelapp.cl/success")) {
          //         webViewController?.goBack();

          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => const AprobadoPage()),
          //         );

          //         return;
          //       } else if (url
          //           .toString()
          //           .contains("https://www.echnelapp.cl/failure")) {
          //         webViewController?.goBack();
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => const RechazadoPage()),
          //         );

          //         return;
          //       } else if (url
          //           .toString()
          //           .contains("https://www.echnelapp.cl/pending")) {
          //         webViewController?.goBack();
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => const PendientePage()),
          //         );
          //       }
          //     })
        ],
      ),
    ));
  }
}
