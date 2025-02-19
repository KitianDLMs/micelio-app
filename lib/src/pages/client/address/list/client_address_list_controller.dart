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
  final trade = GetStorage().read('trade');

  var radioValue = RxnInt(null);

  Future<List<Address>> getAddress() async {
    address = await addressProvider.findByUser(user.id ?? '');

    Address a = Address.fromJson(GetStorage().read('address') ?? {});

    int index = address.indexWhere((ad) => ad.id == a.id);

    if (index != -1) {
      radioValue.value = index;
    }

    return address;
  }

  void createOrder(BuildContext context) async {
    final socketService = Provider.of<SocketService>(context, listen: false);
    Address a = Address.fromJson(GetStorage().read('address') ?? {});
    int index = address.indexWhere((ad) => ad.id == a.id);

    print('address ${a.neighborhood}');

    Map<String, double> deliveryPrices = {
      "Huertos Familiares": 1000.0,
      "Los Lingues": 1500.0,
      "Santa Matilde": 2000.0,
      "Alto el manzano": 2500.0,
    };

    double? deliveryPrice = deliveryPrices[a.neighborhood];
    GetStorage().write('deliveryPrice', deliveryPrice);

    if (deliveryPrice == null) {
      print("No hay precio de entrega para el vecindario: ${a.neighborhood}");
      Fluttertoast.showToast(
          msg: "No hay precio de entrega para el vecindario.",
          toastLength: Toast.LENGTH_LONG);
      return;
    }

    List<Product> selectedProducts = [];
    var storedProducts = GetStorage().read('shopping_bag_${trade.id}');
    if (storedProducts is List) {
      try {
        selectedProducts = storedProducts.map((item) {
          if (item is Product) {
            return item;
          } else if (item is Map<String, dynamic>) {
            return Product.fromJson(item);
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
          "Error: Se esperaba una lista para 'shopping_bag_${trade.id}', pero se recibió: $storedProducts");
    }

    if (selectedProducts.isEmpty) {
      Fluttertoast.showToast(
          msg: "No hay productos en el carrito.",
          toastLength: Toast.LENGTH_LONG);
      return;
    }

    sendPayment(context);

    List<Address> addresses = [];
    var storedAddress = GetStorage().read('address');

    if (storedAddress is List) {
      try {
        addresses = Address.fromJsonList(storedAddress);
      } catch (e) {
        print("Error al procesar las direcciones almacenadas: $e");
      }
    } else if (storedAddress is Map<String, dynamic>) {
      try {
        addresses = [Address.fromJson(storedAddress)];
      } catch (e) {
        print("Error al procesar la dirección almacenada: $e");
      }
    } else {
      print(
          "Error: Se esperaba una lista o un objeto para 'address', pero se recibió: $storedAddress");
    }

    if (addresses.isEmpty) {
      print("Error: No hay direcciones disponibles.");
      Fluttertoast.showToast(
          msg: "No hay direcciones disponibles.",
          toastLength: Toast.LENGTH_LONG);
      return;
    }

    Order order = Order(
        clientId: user.id,
        addressId: addresses[0].id,
        products: selectedProducts,
        tradeId: trade.id,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        deliveryPrice: deliveryPrice);

    ResponseApi responseApi = await ordersProvider.create(order);
    if (responseApi.success == true) {
      socketService.socket.emit('pedido-realizado', {
        'de': user.id,
        'para': trade.userId,
        'nombre': '¡Pedido realizado!',
        'mensaje': 'se te ha hecho un pedido, revisalo',
      });
      GetStorage().remove('shopping_bag_${trade.id}');
      Fluttertoast.showToast(
          msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
    } else {
      print("Error al crear el pedido: ${responseApi.message}");
      Fluttertoast.showToast(
          msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
    }
  }

  void sendPayment(BuildContext context) async {
    List<Product> selectedProducts = [];
    var storedProducts = GetStorage().read('shopping_bag_${trade.id}');
    if (storedProducts == null) {
      Fluttertoast.showToast(
          msg: "El carrito está vacío para este comercio.",
          toastLength: Toast.LENGTH_LONG);
      return;
    }
    if (storedProducts is List) {
      try {
        selectedProducts = storedProducts.map((item) {
          if (item is Product) {
            return item;
          } else if (item is Map<String, dynamic>) {
            return Product.fromJson(item);
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
          "Error: Se esperaba una lista para 'shopping_bag_${trade.id}', pero se recibió: $storedProducts");
      Fluttertoast.showToast(
          msg: "Error al acceder al carrito.", toastLength: Toast.LENGTH_LONG);
      return;
    }

    if (selectedProducts.isEmpty) {
      print("Error: No hay productos en el bag para este comercio.");
      Fluttertoast.showToast(
          msg: "No hay productos en el carrito.",
          toastLength: Toast.LENGTH_LONG);
      return;
    }

    var priceDeli = GetStorage().read('deliveryPrice');
    double deliveryPrice = priceDeli ?? 0.0;

    // Calcular el total de los productos
    double totalAmount = selectedProducts.fold(0.0, (sum, product) {
      return sum + (product.price! * product.quantity!);
    });

    // Sumar deliveryPrice al total
    double totalWithDelivery = totalAmount + deliveryPrice;

    // Crear el 'bag' con el total actualizado
    final bag = selectedProducts.map((product) {
      return {
        "id": product.id,
        "title": product.name,
        "description": product.description,
        "quantity": product.quantity,
        "unit_price": product.price,
        "accessTokenMP": trade.mercadoPagoACTK
      };
    }).toList();

    // Agregar la propiedad 'deliveryPrice' al bag
    bag.add({
      "id": "delivery",
      "title": "Delivery",
      "description": "Costo de entrega",
      "quantity": 1,
      "unit_price": deliveryPrice,
      "accessTokenMP": trade.mercadoPagoACTK
    });

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
      print('Error: ${response.body}');
      Fluttertoast.showToast(
          msg: "Error MercadoPago", toastLength: Toast.LENGTH_LONG);
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
    GetStorage().write('address', address[value].toJson());
    var sadd = GetStorage().read('address');
    update();
  }

  void goToAddressCreate() {
    Get.toNamed('/client/address/create');
  }
}
