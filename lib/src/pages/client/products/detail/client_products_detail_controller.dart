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

  void addToBag(Product product, var price, var counter) {
    var userSession = User.fromJson(GetStorage().read('user') ?? {}).obs;
    int index = selectedProducts.indexWhere((p) => p.id == product.id);

    if (userSession.value.id != null) {
      if (counter.value > 0) {
        if (index == -1) {
          if (product.quantity == null) {
            if (counter.value > 0) {
              product.quantity = counter.value;
            } else {
              product.quantity = 1;
            }
          }

          selectedProducts.add(product);
        } else {
          selectedProducts[index].quantity = counter.value;
        }
        createPreferenceBody();
        GetStorage().write('shopping_bag', selectedProducts);
        Fluttertoast.showToast(msg: 'Producto agregado');

        productsListController.items.value = 0;
        selectedProducts.forEach((p) {
          productsListController.items.value =
              productsListController.items.value + p.quantity!;
        });
      } else {
        Fluttertoast.showToast(
            msg: 'Debes seleccionar al menos un item para agregar',
            toastLength: Toast.LENGTH_LONG);
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Debes iniciar sesión para agegar',
          toastLength: Toast.LENGTH_LONG);
    }
  }

  void addItem(Product product, var price, var counter) {
    counter.value = counter.value + 1;
    price.value = product.price! * counter.value;
  }

  void removeItem(Product product, var price, var counter) {
    if (counter.value > 0) {
      counter.value = counter.value - 1;
      price.value = product.price! * counter.value;
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
