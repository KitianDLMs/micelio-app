import 'package:micelio/src/models/category.dart';
import 'package:micelio/src/models/product.dart';
import 'package:micelio/src/models/response_api.dart';
import 'package:micelio/src/models/trade..dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/providers/categories_provider.dart';
import 'package:micelio/src/providers/products_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:micelio/src/providers/trade_provider.dart';

class RestaurantHomeTradeController extends GetxController {
  final CategoriesProvider categoriesProvider = CategoriesProvider();
  final ProductsProvider productsProvider = ProductsProvider();
  final TradeProvider tradeProvider = TradeProvider();
  final TextEditingController openingHoursController = TextEditingController();
  final TextEditingController closingHoursController = TextEditingController();
  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  var trade = Rxn<Trade>();
  var categories = <Category>[].obs;
  var selectedProducts = <Product>[];
  var isLoading = false.obs;
  var items = 0.obs;
  var productName = ''.obs;
  var isOpen = false.obs;
  Timer? searchOnStoppedTyping;

  @override
  void onInit() {
    super.onInit();
    fetchTrade();
  }

  Future<void> fetchTrade() async {
    try {
      isLoading(true);
      var storage = userSession.tradeId;
      trade.value = await tradeProvider.getById(storage!);
      if (trade.value != null) {
        openingHoursController.text = trade.value!.openingHours ?? '';
        closingHoursController.text = trade.value!.closingHours ?? '';
        isOpen.value = trade.value!.isOpen ?? false;
      }
    } catch (e) {
      print('Error al obtener el trade: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateHours() async {
    try {
      isLoading(true);
      if (trade.value == null) return;
      
      Map<String, dynamic> updatedFields = {
        'isOpen': isOpen.value,
      };
      if (openingHoursController.text != trade.value!.openingHours) {
        updatedFields['openingHours'] = openingHoursController.text;
      }
      if (closingHoursController.text != trade.value!.closingHours) {
        updatedFields['closingHours'] = closingHoursController.text;
      }
      
      if (updatedFields.isNotEmpty) {
        ResponseApi response = await tradeProvider.update(updatedFields, trade.value!.id!);
        if (response.success == true) {
          await fetchTrade(); // Recargar datos actualizados
          Get.snackbar('Éxito', response.message ?? 'Horario actualizado correctamente');
        } else {
          Get.snackbar('Error', response.message ?? 'No se pudo actualizar');
        }
      }
    } catch (e) {
      print('Error al actualizar el horario: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> toggleOpenStatus() async {
    try {
      isLoading(true);
      if (trade.value == null) return;
      
      bool newStatus = !isOpen.value;
      ResponseApi response = await tradeProvider.update({'isOpen': newStatus}, trade.value!.id!);
      
      if (response.success == true) {
        isOpen.value = newStatus;
        Get.snackbar('Éxito', 'Estado actualizado correctamente');
      } else {
        Get.snackbar('Error', response.message ?? 'No se pudo actualizar el estado');
      }
    } catch (e) {
      print('Error al actualizar el estado de apertura: $e');
    } finally {
      isLoading(false);
    }
  }
}
