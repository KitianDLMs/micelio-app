import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/pages/client/orders/list/client_orders_list_page.dart';
import 'package:micelio/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:micelio/src/pages/client/home/client_home_controller.dart';
import 'package:micelio/src/pages/client/products/list/client_products_list_page.dart';
import 'package:micelio/src/providers/noti_service.dart';
import 'package:micelio/src/providers/socket_service.dart';
import 'package:micelio/src/utils/custom_animated_bottom_bar.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientHomePage extends StatefulWidget {
  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  ClientHomeController con = Get.put(ClientHomeController());
  User userSession = User.fromJson(GetStorage().read('user') ?? {});  

  @override
  void initState() {
    super.initState();
    final socketService = Provider.of<SocketService>(context, listen: false);    
    socketService.connect();
    socketService.socket.on('pedido-iniciado', _pedidoIniciado);
    socketService.socket.on('pedido-entregado', _pedidoEntregado);    
  }

  void _pedidoIniciado(dynamic data) {
    NotiService().showNotification(
      id: 200, 
      title: '¡En camino!', 
      body: 'Pedido en camino, ¡preparate!'
    );
    setState(() {});
  }  

  void _pedidoEntregado(dynamic data) {
    NotiService().showNotification(
      id: 200, 
      title: 'Pedido entregado!', 
      body: 'Se entrego tu pedido, ¡disfrutalo!'
    );
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
                children: [
                  ClientProductsListPage(),
                  ClientOrdersListPage(),
                  ClientProfileInfoPage()
                ],
              )),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: _socialMediaIcons()),
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
                title: Text('Productos'),
                activeColor: Colors.white,
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                icon: Icon(Icons.list),
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

  Widget _socialMediaIcons() {
    var fbMic =
        Uri.parse('https://www.facebook.com/profile.php?id=100011652091695');
    var igMic =
        Uri.parse('https://www.instagram.com/micelio_pizzasysandwichs/');
    var wsMic = Uri.parse('https://wa.me/56990959383');
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 10, horizontal: 20), // Agrega padding horizontal
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Distribuye los íconos
        children: [
          _animatedIconButton(
            icon: FontAwesome.facebook,
            color: Colors.blue,
            onPressed: () => _launchUrl(fbMic),
          ),
          _animatedIconButton(
            icon: FontAwesome.instagram,
            color: Colors.purple,
            onPressed: () => _launchUrl(igMic),
          ),
          _animatedIconButton(
            icon: FontAwesome.whatsapp,
            color: Colors.green,
            onPressed: () => _launchUrl(wsMic),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    await launchUrl(url);
  }

  Widget _animatedIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    double _scale = 1.0;

    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTapDown: (_) {
            setState(() => _scale = 0.9);
          },
          onTapUp: (_) {
            setState(() => _scale = 1.0);
            onPressed();
          },
          onTapCancel: () {
            setState(() => _scale = 1.0);
          },
          child: AnimatedScale(
            scale: _scale,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
        );
      },
    );
  }
}
