import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/preference.dart';
import 'package:micelio/src/models/product.dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/pages/client/products/list/client_products_list_controller.dart';

class ClientProductsDetailController extends GetxController {
  List<Product> selectedProducts = [];
  ClientProductsListController productsListController = Get.find();

  void checkIfProductsWasAdded(Product product, var price, var counter) {
    price.value = product.price ?? 0.0;
    if (GetStorage().read('shopping_bag') != null) {
      if (GetStorage().read('shopping_bag') is List<Product>) {
        selectedProducts = GetStorage().read('shopping_bag');
      } else {
        selectedProducts =
            Product.fromJsonList(GetStorage().read('shopping_bag'));
      }
      int index = selectedProducts.indexWhere((p) => p.id == product.id);

      if (index != -1) {
        counter.value = selectedProducts[index].quantity!;
        price.value = product.price! * counter.value;
      }
    }
  }

  void addToBag(Product product, RxInt counter) {
    var userSession = User.fromJson(GetStorage().read('user') ?? {});
    var trade = GetStorage().read('trade');
    if (trade != null && trade.id != null) {
      if (userSession.id != null) {
        if (counter.value > 0) {
          product.quantity = counter.value;
          addToShoppingBag(product);
          Fluttertoast.showToast(msg: 'Producto agregado al carrito');
        } else {
          Fluttertoast.showToast(
              msg: 'Debes seleccionar al menos un item para agregar');
        }
      } else {
        Fluttertoast.showToast(
            msg: 'Debes iniciar sesión para agegar',
            toastLength: Toast.LENGTH_LONG);
      }
    } else {
      Fluttertoast.showToast(msg: 'Error al obtener el trade.');
    }
  }

  void addToShoppingBag(Product product) {
    var trade = GetStorage().read('trade');
    
    if (trade != null && trade.id != null) {      
      List<dynamic> savedProducts =
          GetStorage().read('shopping_bag_${trade.id}') ?? [];
      print('savedProducts $savedProducts');

      var matchingProducts =
          savedProducts.where((item) => item["id"] == product.id);

      if (matchingProducts.isEmpty) {
        print('Producto no encontrado');
        savedProducts.add(product.toJson());
      } else {
        var existingProduct = matchingProducts.first;
        existingProduct["quantity"] += product.quantity;        
      }

      GetStorage().write('shopping_bag_${trade.id}', savedProducts);
      print('savedProducts $savedProducts');
    }
  }

  void addItem(Product product, RxDouble price, RxInt counter) {    
    counter.value += 1;
    price.value = product.price! * counter.value;

    var trade = GetStorage().read('trade');
    if (trade != null && trade.id != null) {
      List<dynamic> savedProducts =
          GetStorage().read('shopping_bag_${trade.id}') ?? [];

      var existingProduct = selectedProducts.any((p) => p.id == product.id)
          ? selectedProducts.firstWhere((p) => p.id == product.id)
          : null;

      if (existingProduct == null) {
        print('El elemento no fue encontrado');
        return;
      }

      if (existingProduct != null) {        
        existingProduct.quantity = counter.value;
      } else {        
        product.quantity = counter.value;
        savedProducts.add(product.toJson());
      }

      GetStorage().write('shopping_bag_${trade.id}', savedProducts);
    }
  }

  void removeItem(Product product, RxDouble price, RxInt counter) {
    if (counter.value > 0) {
      counter.value = counter.value - 1;
      price.value = product.price! * counter.value;
      
      var trade = GetStorage().read('trade');
      if (trade != null && trade.id != null) {
        List<dynamic> savedProducts =
            GetStorage().read('shopping_bag_${trade.id}') ?? [];

        var existingProduct = savedProducts.firstWhere(
          (item) => item["id"] == product.id,
          orElse: () => null,
        );

        if (existingProduct != null) {          
          if (counter.value == 0) {
            savedProducts.removeWhere((item) => item["id"] == product.id);
          } else {            
            existingProduct["quantity"] = counter.value;
          }

          GetStorage().write('shopping_bag_${trade.id}', savedProducts);
        }
      }
    }
  }

  void createPreferenceBody() {
    var selectedProducts = GetStorage().read('shopping_bag') ?? [];
  }

  Map<String, dynamic> convertToServerFormat(List<dynamic> preferences) {
    return {
      'items': preferences.map((preference) {
        return {
          'title': preference.name,
          'quantity': preference.quantity,
          'unit_price': preference.price,
          'currency_id': "CLP",
        };
      }).toList(),
      'back_urls': {
        'success': "https://www.facebook.com/",
        'failure': "https://www.instagram.com/",
        'pending': "https://www.whatsapp.com/",
      },
      'auto_return': "approved",
    };
  }
}
