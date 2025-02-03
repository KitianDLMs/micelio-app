import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/order.dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/providers/orders_provider.dart';

class DeliveryOrdersListController extends GetxController {

  OrdersProvider ordersProvider = OrdersProvider();
  List<String> status = <String>['DESPACHADO', 'ENCAMINO', 'ENTREGADO'].obs;

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  Future<List<Order>> getOrders(String status) async {    
    return await ordersProvider.findByDeliveryAndStatus(userSession.id ?? '0', status);
  }

  void goToOrderDetail (Order order) {{}
    Get.toNamed('/delivery/orders/detail', arguments: {
      'order': order.toJson()
    });
  }
}