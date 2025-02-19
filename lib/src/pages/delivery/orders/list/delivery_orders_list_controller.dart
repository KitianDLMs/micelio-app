import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/order.dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/providers/orders_provider.dart';

class DeliveryOrdersListController extends GetxController {
  OrdersProvider ordersProvider = OrdersProvider();
  List<String> status = <String>['DESPACHADO', 'ENCAMINO', 'ENTREGADO'].obs;
  List<dynamic> trades = [];
  List<dynamic> allTrades = [];
  var selectedTrade = Rx<String?>(null);
  int contador = 0;

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  void setSelectedTrade(String trade) {
    selectedTrade.value = trade;
  }

  Future<List<Order>> getOrders(String status) async {
    var orders = await ordersProvider.findByDeliveryAndStatus(
        userSession.id ?? '0', status);
    orders.forEach((o) {
      var newT = o.tradeId;
      if (newT != null && !trades.contains(newT)) {
        trades.add(newT);
      }
      contador++;
    });
    allTrades = orders;    
    return orders;
  }

  void goToOrderDetail(Order order) {
    Get.toNamed('/delivery/orders/detail',
        arguments: {'order': order.toJson()});
  }
}
