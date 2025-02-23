import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:micelio/src/pages/client/home/client_home_controller.dart';
import 'package:micelio/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:micelio/src/providers/noti_service.dart';
import 'package:micelio/src/providers/socket_service.dart';
import 'package:micelio/src/utils/custom_animated_bottom_bar.dart';
import 'package:provider/provider.dart';

class DeliveryHomePage extends StatefulWidget {
  @override
  State<DeliveryHomePage> createState() => _DeliveryHomePageState();
}

class _DeliveryHomePageState extends State<DeliveryHomePage> {
  ClientHomeController con = Get.put(ClientHomeController());

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  @override
  void initState() {
    super.initState();
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.connect();
    socketService.socket.on('pedido-asignado', _pedidoAsignado);
    socketService.socket.on('pedido-entregado', _pedidoEntregado);
  }

  void _pedidoAsignado(dynamic data) {
    NotiService().showNotification(
        id: 200,
        title: 'Pedido asignado',
        body: 'Se te asignó un pedido, revisalo');
    setState(() {});
  }

  void _pedidoEntregado(dynamic data) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService()),
      ],
      child: Scaffold(
        bottomNavigationBar: SafeArea(child: _bottomBar()),
        body: Obx(() => IndexedStack(
              index: con.indexTab.value,
              children: [DeliveryOrdersListPage(), ClientProfileInfoPage()],
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _bottomBar() {
    return Obx(() => CustomAnimatedBottomBar(
          containerHeight: 70,
          backgroundColor: Colors.amber,
          showElevation: true,
          itemCornerRadius: 24,
          curve: Curves.easeIn,
          selectedIndex: con.indexTab.value,
          onItemSelected: (index) => con.changeTab(index),
          items: [
            BottomNavyBarItem(
                icon: Icon(Icons.apps),
                title: Text('Pedidos'),
                activeColor: Colors.white,
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                icon: Icon(Icons.person),
                title: Text('Perfil'),
                activeColor: Colors.white,
                inactiveColor: Colors.black),
          ],
        ));
  }
}
