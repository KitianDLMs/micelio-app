import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/order.dart';
import 'package:micelio/src/models/response_api.dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/providers/orders_provider.dart';
import 'package:micelio/src/providers/socket_service.dart';
import 'package:micelio/src/providers/users_provider.dart';
import 'package:provider/provider.dart';

class DeliveryOrdersDetailController extends GetxController {
  Order order = Order.fromJson(Get.arguments['order']);

  var total = 0.0.obs;
  var idDelivery = ''.obs;

  bool isClose = false;

  UsersProvider usersProvider = UsersProvider();
  OrdersProvider ordersProvider = OrdersProvider();
  List<User> users = <User>[].obs;

  DeliveryOrdersDetailController() {
    getTotal();
  }

  User user = User.fromJson(GetStorage().read('user') ?? {});

  Future<List<Order>> getOrders(String status) async {
    return await ordersProvider.findByDeliveryAndStatus(user.id ?? '0', status);
  }

  void updateOrder(context) async {
    final socketService = Provider.of<SocketService>(context, listen: false);
    order.deliveryId = idDelivery.value;
    ResponseApi responseApi = await ordersProvider.updateToOnTheWay(order);
    if (responseApi.success == true) {
      socketService.socket.emit('pedido-iniciado', {
        'de': user.id,
        'para': order.clientId,
        'nombre': '¡Se inicia entrega!',
        'mensaje': 'se ha iniciado el recorrido de tu pedido',
      });
      Get.offNamedUntil('/delivery/home', (route) => false);
    } else {
      print('${responseApi.success}');
    }
  }

  void goToOrderMap() {
    Get.toNamed('/delivery/orders/home', arguments: {'order': order.toJson()});
  }

  void updateToDelivered(context) async {
    final socketService = Provider.of<SocketService>(context, listen: false);
    ResponseApi responseApi = await ordersProvider.updateToDelivered(order);
    Fluttertoast.showToast(
        msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
    if (responseApi.success == true) {
      socketService.socket.emit('pedido-entregado', {
        'de': user.id,
        'para': order.clientId,
        'nombre': '¡Pedido asignado!',
        'mensaje': 'se te ha asignado un pedido, revisalo',
      });
      Get.offNamedUntil('/delivery/home', (route) => false);
    } else {
      Get.snackbar('Operacion no permitida',
          'Hubo un problema al actualiazar el pedido a entregado');
    }
  }

  void getTotal() {
    total.value = 0.0;
    order.products!.forEach((product) {
      total.value = total.value + (product.quantity! * product.price!);
    });
  }
}
