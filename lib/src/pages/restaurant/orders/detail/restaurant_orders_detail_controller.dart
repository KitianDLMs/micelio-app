import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/main.dart';
import 'package:micelio/src/models/order.dart';
import 'package:micelio/src/models/response_api.dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/providers/orders_provider.dart';
import 'package:micelio/src/providers/socket_service.dart';
import 'package:micelio/src/providers/users_provider.dart';
import 'package:provider/provider.dart';

class RestaurantOrdersDetailController extends GetxController {
  Order order = Order.fromJson(Get.arguments['order']);
  
  var total = 0.0.obs;
  var idDelivery = ''.obs;
  var deliveryId;

  UsersProvider usersProvider = UsersProvider();
  OrdersProvider ordersProvider = OrdersProvider();
  List<User> users = <User>[].obs;
  User user = User.fromJson(GetStorage().read('user') ?? {});

  RestaurantOrdersDetailController() {
    getDeliveryMen();
    getTotal();
  }

  void updateOrder(context) async {
    final socketService = Provider.of<SocketService>(context, listen: false);             
    if (idDelivery.value != '') {
      order.deliveryId = idDelivery.value;      
      ResponseApi responseApi = await ordersProvider.updateToDispatched(order);
      if (responseApi.success == true) {
        socketService.socket.emit('pedido-asignado', {
          'de': user.id,
          'para': order.deliveryId,
          'nombre': '¡Pedido asignado!',
          'mensaje': 'se te ha asignado un pedido, revisalo',
        });
        socketService.socket.emit('pedido-asignado', {
          'de': user.id,
          'para': order.clientId,
          'nombre': '¡Pedido asignado!',
          'mensaje': 'se asignado un repartidor, ya casi',
        });
        Get.offNamedUntil('/restaurant/home', (route) => false);
      } else {}
    } else {
      Get.snackbar('Petición denegada', 'Debes asignar el repartidor');
    }
  }

  void getDeliveryMen() async {
    var result = await usersProvider.findDeliveryMen();
    users.clear();
    users.addAll(result);
  }

  void getTotal() {
    total.value = 0.0;
    order.products!.forEach((product) {
      total.value = total.value + (product.quantity! * product.price!);
    });
  }
}
