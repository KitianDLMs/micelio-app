import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/order.dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/providers/noti_service.dart';
import 'package:micelio/src/providers/orders_provider.dart';

class ClientOrdersListController extends GetxController {
  User userSession = User.fromJson(GetStorage().read('user') ?? {});
  OrdersProvider ordersProvider = OrdersProvider();
  List<String> status =
      <String>['PAGADO', 'DESPACHADO', 'ENCAMINO', 'ENTREGADO'].obs;

  User user = User.fromJson(GetStorage().read('user') ?? {});

  Future<List<Order>> getOrders(String status) async {
    if (userSession.id == null) {      
      return [];
    }
    return await ordersProvider.findByClientAndStatus(user.id ?? '0', status);
  }

  showNotificationPagado() {
    NotiService().showNotification(title: 'Pedido Pagado', body: 'pedido realizado con éxito');
  }

  showNotificationDespachado() {
    NotiService().showNotification(title: 'Pedido Asignado', body: 'el repartidor debe iniciar su entrega');
  }

  showNotificationEncamino() {
    NotiService().showNotification(title: 'Pedido en camino', body: 'preparate para recibir tu pedido');
  }

  showNotificationEntregado() {
    NotiService().showNotification(title: 'Pedido en entregado', body: '¡disfruta tu pedido!');
  }

  void goToOrderDetail(Order order) {
    Get.toNamed('/client/orders/detail', arguments: {'order': order.toJson()});
  }
}
