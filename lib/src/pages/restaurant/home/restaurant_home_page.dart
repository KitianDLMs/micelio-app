import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:micelio/src/models/trade..dart';
import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/pages/client/orders/list/client_orders_list_page.dart';
import 'package:micelio/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:micelio/src/pages/client/home/client_home_controller.dart';
import 'package:micelio/src/pages/client/products/list/client_products_list_page.dart';
import 'package:micelio/src/pages/restaurant/categories/create/restaurant_categories_create_page.dart';
import 'package:micelio/src/pages/restaurant/home/restaurant_home_controller.dart';
import 'package:micelio/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:micelio/src/pages/restaurant/products/create/restaurant_products_create_page.dart';
import 'package:micelio/src/pages/restaurant/products/home/restaurant_product_home_page.dart';
import 'package:micelio/src/pages/restaurant/products/list/restaurant_products_list_page.dart';
import 'package:micelio/src/pages/restaurant/trade/create/restaurant_trade_create_page.dart';
import 'package:micelio/src/pages/restaurant/trade/home/reataurant_home_trade_page.dart';
import 'package:micelio/src/providers/noti_service.dart';
import 'package:micelio/src/providers/socket_service.dart';
import 'package:micelio/src/utils/custom_animated_bottom_bar.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantHomePage extends StatefulWidget {
  @override
  State<RestaurantHomePage> createState() => _RestaurantHomePageState();
}

class _RestaurantHomePageState extends State<RestaurantHomePage> {
  RestaurantHomeController con = Get.put(RestaurantHomeController());
  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  @override
  void initState() {    
    super.initState();    
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.connect();
    socketService.socket.on('pedido-realizado', _pedidoRealizado);
    socketService.socket.on('pedido-entregado', _pedidoEntregado);
  }

  void _pedidoRealizado(dynamic data) {
      NotiService().showNotification(
        id: 200, 
        title: 'Pedido Realizado', 
        body: 'Pedido Realizado, revisalo'
      );
      setState(() {});
  }

  void _pedidoEntregado(dynamic data) {
    NotiService().showNotification(
        id: 200,
        title: 'Pedido entregado!',
        body: 'Se entrego tu pedido, ¡disfrutalo!');
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
                  userSession.tradeId == null ? 
                     RestaurantTradeCreatePage() : 
                     RestaurantHomeTradePage(),
                  RestaurantOrdersListPage(),
                  RestaurantCategoriesCreatePage(),
                  // RestaurantProductsCreatePage(),
                  RestaurantProductHomePage(),
                  ClientProfileInfoPage()
                ],
              )),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
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
                icon: Icon(Icons.store),
                title: Text('Tienda'),
                activeColor: Colors.white,
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                icon: Icon(Icons.list),
                title: Text('Pedidos'),
                activeColor: Colors.white,
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                icon: Icon(Icons.category),
                title: Text('Categoria'),
                activeColor: Colors.white,
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                icon: Icon(Icons.restaurant),
                title: Text('Producto'),
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
    // var fbMic =
    //     Uri.parse('${trade.tradeFacebook ?? ''}');
    // var igMic =
    //     Uri.parse('${trade.tradeInstagram ?? ''}');
    // var wsMic = Uri.parse('${trade.tradeWsp ?? ''}');
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          // _animatedImageButton(
          //   imagePath: '${trade.image}',
          //   onPressed: () => con.goToTrade()
          // ),
          // _animatedIconButton(
          //   icon: FontAwesome.facebook,
          //   color: Colors.blue,
          //   onPressed: () => _launchUrl(fbMic),
          // ),
          // _animatedIconButton(
          //   icon: FontAwesome.instagram,
          //   color: Colors.purple,
          //   onPressed: () => _launchUrl(igMic),
          // ),
          // _animatedIconButton(
          //   icon: FontAwesome.whatsapp,
          //   color: Colors.green,
          //   onPressed: () => _launchUrl(wsMic),
          // ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    await launchUrl(url);
  }

  Widget _animatedImageButton({
    required String imagePath,
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imagePath,
                width: 38,
                height: 38,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.error,
                    size: 40,
                    color: Colors.red,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
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

  // Widget _tradeImageWidget() {
  //   if (trade == null || trade['image'] == null) {
  //     return Center(
  //       child: Text(
  //         'No hay imagen disponible',
  //         style: TextStyle(fontSize: 18, color: Colors.grey),
  //       ),
  //     );
  //   }
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Text(
  //           'Imagen del Trade',
  //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //         ),
  //         SizedBox(height: 10),
  //         Container(
  //           width: 150,
  //           height: 150,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(10),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black26,
  //                 blurRadius: 10,
  //                 offset: Offset(0, 5),
  //               ),
  //             ],
  //           ),
  //           child: ClipRRect(
  //             borderRadius: BorderRadius.circular(10),
  //             child: Image.network(
  //               trade['image'],
  //               fit: BoxFit.cover,
  //               errorBuilder: (context, error, stackTrace) {
  //                 return Center(
  //                   child: Text('Error al cargar imagen'),
  //                 );
  //               },
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
