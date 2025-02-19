import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/order.dart';
import 'package:micelio/src/providers/orders_provider.dart';

class RestaurantOrdersListController extends GetxController {
  OrdersProvider ordersProvider = OrdersProvider();
  
  List<String> status =
      <String>['PAGADO', 'DESPACHADO', 'ENCAMINO', 'ENTREGADO'].obs;
  
  @override
  void onInit() {
    super.onInit();
    var user = GetStorage().read('user');
    String tradeId = user['tradeId'];
  }

  Future<List<Order>> getOrders(String status) async {    
    List<Order> orders = await ordersProvider.findByStatus(status);    
    var user = GetStorage().read('user');
    String tradeId = user['tradeId'];
    return orders.where((order) => order.tradeId == tradeId).toList();
  }

  void goToOrderDetail(Order order) {
    Get.toNamed('/restaurant/orders/detail',
        arguments: {'order': order.toJson()});
  }
}
