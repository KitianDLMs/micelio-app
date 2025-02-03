import 'package:micelio/src/models/category.dart';
import 'package:micelio/src/models/product.dart';
import 'package:micelio/src/pages/client/products/detail/client_products_detail_page.dart';
import 'package:micelio/src/providers/categories_provider.dart';
import 'package:micelio/src/providers/products_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientProductsListController extends GetxController {
  CategoriesProvider categoriesProvider = CategoriesProvider();
  ProductsProvider productsProvider = ProductsProvider();

  List<Product> selectedProducts = [];

  List<Category> categories = <Category>[].obs;
  var isLoading = true.obs;
  var items = 0.obs;

  var productName = ''.obs;
  Timer? searchOnStoppedTyping;

  ClientProductsListController() {
    // getProducts(idCategory, productName);
    getCategories();
    if (GetStorage().read('shopping_bag') != null) {
      if (GetStorage().read('shopping_bag') is List<Product>) {
        selectedProducts = GetStorage().read('shopping_bag');
      } else {
        selectedProducts =
            Product.fromJsonList(GetStorage().read('shopping_bag'));
      }

      selectedProducts.forEach((p) {
        items.value = items.value + (p.quantity!);
      });
    }
  }

  void onChangeText(String text) {
    const duration = Duration(milliseconds: 800);
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping?.cancel();
    }

    searchOnStoppedTyping = Timer(duration, () {
      productName.value = text;
    });
  }

  @override
  void onInit() {
    super.onInit();
    getCategories();
  }  

  Future<void> getCategories() async {
    isLoading.value = true;
    try {
      categories.assignAll(await categoriesProvider.getAll());
    } catch (e) {
      print('Error al cargar categorías: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // void getCategories() async {
  //   var result = ;
  //   categories.clear();
  //   categories.addAll(result);
  // }

  Future<List<Product>> getProducts(
      String idCategory, String productName) async {
    try {
      return productName.isEmpty
          ? await productsProvider.findByCategory(idCategory)
          : await productsProvider.findByNameAndCategory(
              idCategory, productName);
    } catch (e) {
      print('Error al cargar productos: $e');
      return [];
    }
  }

  void goToOrderCreate() {
    Get.toNamed('/client/orders/create');
  }

  void openBottomSheet(BuildContext context, Product product) async {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => ClientProductsDetailPage(
        product: product,
      ),
    );
  }
}
