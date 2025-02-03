import 'dart:ffi';

import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:micelio/src/models/order.dart';
import 'package:micelio/src/models/product.dart';
import 'package:micelio/src/models/response_api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:micelio/src/models/address.dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/pages/client/payments/pays/pago_page.dart';
import 'package:micelio/src/providers/address_provider.dart';
import 'package:micelio/src/providers/mercadopago_provider.dart';
import 'package:micelio/src/providers/noti_service.dart';
import 'package:micelio/src/providers/orders_provider.dart';
import 'package:micelio/src/providers/socket_service.dart';
import 'package:provider/provider.dart';

class ClientAddressListController extends GetxController {
  List<Address> address = [];
  AddressProvider addressProvider = AddressProvider();
  OrdersProvider ordersProvider = OrdersProvider();
  MercadopagoProvider mercadopagoProvider = MercadopagoProvider();  

  User user = User.fromJson(GetStorage().read('user') ?? {});
  final bag = GetStorage().read('shopping_bag');

  var radioValue = RxnInt(null);

  Future<List<Address>> getAddress() async {
    address = await addressProvider.findByUser(user.id ?? '');

    print(GetStorage().read('address'));
    Address a = Address.fromJson(GetStorage().read('address') ?? {});

    int index = address.indexWhere((ad) => ad.id == a.id);

    if (index != -1) {
      radioValue.value = index;
    }

    return address;
  }

  void createOrder(context) async {
    final socketService = Provider.of<SocketService>(context, listen: false);
    List<Product> selectedProducts = [];    
    var storedProducts = GetStorage().read('shopping_bag');    
    if (storedProducts is List) {      
      try {
        selectedProducts = storedProducts.map((item) {
          if (item is Product) {
            return item;
          } else if (item is Map<String, dynamic>) {
            return Product.fromJson(
                item);
          } else {
            throw Exception(
                "Elemento inesperado en la lista: $item (${item.runtimeType})");
          }
        }).toList();
      } catch (e) {
        print("Error al procesar los productos almacenados: $e");
      }
    } else {
      print(
          "Error: Se esperaba una lista para 'shopping_bag', pero se recibió: $storedProducts");
    }

    List<Address> a = [];
    var storedAddress = GetStorage().read('address');

    if (storedAddress is List) {
      a = Address.fromJsonList(storedAddress);
    } else if (storedAddress is Map<String, dynamic>) {
      a = [Address.fromJson(storedAddress)];
    } else {
      print(
          "Error: Se esperaba una lista o un objeto, pero se recibió: $storedAddress");
    }

    Order order = Order(
        clientId: user.id,
        addressId: a[0].id,
        products: selectedProducts,
        timestamp: DateTime.now().millisecondsSinceEpoch);

    ResponseApi responseApi = await ordersProvider.create(order);    
    if (responseApi.success == true) {
      socketService.socket.emit('pedido-realizado', {
          'de': user.id,
          'para': '675a07edf5e55b064921a0ee',
          'nombre': '¡Pedido realizado!',
          'mensaje': 'se ha realizado un pedido, revisalo',          
      });       
      GetStorage().remove("shopping_bag ");
      Fluttertoast.showToast(
          msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
      sendPayment(context);
    }
  }

  void sendPayment(context) async {
    Response response = await mercadopagoProvider.create(bag);
    if (response.statusCode == 200) {
      final Map<String, dynamic> res = response.body;
      _launchURL(context, res['url']);
      if (context.mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => PagoPage(
                      url: res["url"],
                    )));
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  void _launchURL(BuildContext context, dynamic url) async {
    final theme = Theme.of(context);
    try {
      await launchUrl(
        Uri.parse('$url'),
        customTabsOptions: CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: theme.colorScheme.surface,
          ),
          shareState: CustomTabsShareState.on,
          urlBarHidingEnabled: true,
          showTitle: true,
          closeButton: CustomTabsCloseButton(
            icon: CustomTabsCloseButtonIcons.back,
          ),
        ),
        safariVCOptions: SafariViewControllerOptions(
          preferredBarTintColor: theme.colorScheme.surface,
          preferredControlTintColor: theme.colorScheme.onSurface,
          barCollapsingEnabled: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void handleRadioValueChange(int? value) {
    radioValue.value = value!;
    // print('VALOR SELECCIONADO ${value}');
    GetStorage().write('address', address[value].toJson());
    var sadd = GetStorage().read('address');
    update();
  }

  void goToAddressCreate() {
    Get.toNamed('/client/address/create');
  }
}
