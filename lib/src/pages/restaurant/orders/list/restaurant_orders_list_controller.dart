import 'package:get/get.dart';
import 'package:micelio/src/models/order.dart';
import 'package:micelio/src/providers/orders_provider.dart';

class RestaurantOrdersListController extends GetxController {
  OrdersProvider ordersProvider = OrdersProvider();
  List<String> status =
      <String>['PAGADO', 'DESPACHADO', 'ENCAMINO', 'ENTREGADO'].obs;

  Future<List<Order>> getOrders(String status) async {
    return await ordersProvider.findByStatus(status);    
  }

  void goToOrderDetail(Order order) {
    Get.toNamed('/restaurant/orders/detail',
        arguments: {'order': order.toJson()});
  }
}
