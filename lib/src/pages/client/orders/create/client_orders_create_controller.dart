import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/product.dart';

class ClientOrdersCreateController extends GetxController {
  RxList<Product> selectedProducts =
      <Product>[].obs; // Usar RxList para reactividad
  RxDouble total = 0.0.obs; // Total a pagar

  @override
  void onInit() {
    super.onInit();
    loadSelectedProducts(); // Cargar productos desde GetStorage al iniciar
  }

  void loadSelectedProducts() {
    var trade = GetStorage().read('trade');
    if (trade != null && trade.id != null) {
      List<dynamic> savedProducts =
          GetStorage().read('shopping_bag_${trade.id}') ?? [];
      selectedProducts.value = savedProducts
          .map((item) {
            try {
              return Product.fromJson(item); // Manejar errores aquí
            } catch (e) {
              print('Error al procesar producto: $e');
              return null; // Ignorar productos inválidos
            }
          })
          .whereType<Product>()
          .toList(); // Filtrar nulos
      calculateTotal();
    }
  }

  void calculateTotal() {
    total.value = selectedProducts.fold(0.0, (sum, product) {
      return sum + (product.price! * product.quantity!);
    });
  }

  void addItem(Product product) {
    var existingProduct = selectedProducts.firstWhere(
      (p) => p.id == product.id,
      orElse: () => Product(
          id: '', name: '', price: 0.0, quantity: 0), // Crear un producto vacío
    );

    if (existingProduct != null) {
      existingProduct.quantity = (existingProduct.quantity ?? 0) + 1;
    } else {
      product.quantity = 1;
      selectedProducts.add(product);
    }

    // Actualizar el almacenamiento
    updateShoppingBag();
  }

  void removeItem(Product product) {
    if (product.quantity! > 1) {
      product.quantity = product.quantity! - 1;
    } else {
      selectedProducts.remove(product);
    }
    updateShoppingBag();
  }

  void deleteItem(Product product) {
    selectedProducts.remove(product);
    updateShoppingBag();
  }

  void updateShoppingBag() {
    var trade = GetStorage().read('trade');
    if (trade != null && trade.id != null) {
      GetStorage().write('shopping_bag_${trade.id}',
          selectedProducts.map((product) => product.toJson()).toList());
      calculateTotal();
    }
  }

  void goToAddressList() {
    Get.toNamed('/client/address/list');
  }
}
