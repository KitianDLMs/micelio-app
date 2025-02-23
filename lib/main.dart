import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:micelio/src/models/user.dart';
import 'package:micelio/src/pages/client/address/create/client_address_create_page.dart';
import 'package:micelio/src/pages/client/address/list/client_address_list_page.dart';
import 'package:micelio/src/pages/client/home-tutorial/client_home_tutorial_page.dart';

import 'package:micelio/src/pages/client/home/client_home_page.dart';
import 'package:micelio/src/pages/client/orders/create/client_orders_create_page.dart';
import 'package:micelio/src/pages/client/orders/detail/client_orders_detail_page.dart';
import 'package:micelio/src/pages/client/payments/installments/client_payments_installments_page.dart';
import 'package:micelio/src/pages/client/products/list/client_products_list_page.dart';
import 'package:micelio/src/pages/client/profile/update/client_profile_update_page.dart';
import 'package:micelio/src/pages/client/trade/trade_home_page.dart';
import 'package:micelio/src/pages/delivery/home/delivery_home_page.dart';
import 'package:micelio/src/pages/delivery/orders/detail/delivery_orders_detail_page.dart';
import 'package:micelio/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:micelio/src/pages/home/home_page.dart';
import 'package:micelio/src/pages/login/login_page.dart';
import 'package:micelio/src/pages/register/register_page.dart';
import 'package:micelio/src/pages/restaurant/home/restaurant_home_page.dart';
import 'package:micelio/src/pages/restaurant/orders/detail/restaurant_orders_detail_page.dart';
import 'package:micelio/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:micelio/src/pages/restaurant/products/create/restaurant_products_create_page.dart';
import 'package:micelio/src/pages/restaurant/products/list/restaurant_products_list_page.dart';
import 'package:micelio/src/pages/roles/roles_page.dart';
import 'package:micelio/src/providers/noti_service.dart';
import 'package:micelio/src/providers/preferences/pref_usuarios.dart';
import 'package:micelio/src/providers/socket_service.dart';
import 'package:provider/provider.dart';

User userSession = User.fromJson(GetStorage().read('user') ?? {});

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  NotiService().initNotification();
  await PreferenciasUsuario.init();
  runApp(
    MultiProvider(
      child: const MyApp(),
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService()),
      ],
    ),
  );  
}

class MyApp extends StatefulWidget {
  const MyApp() : super();
    
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {    
    super.initState();    
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pedidos Huertos',
      debugShowCheckedModeBanner: false,
      initialRoute: userSession.id != null
          ? userSession.roles!.length > 1
              ? '/roles'
              : '/trade'
          : '/home-tutorial',
      getPages: [
        GetPage(name: '/', page: () => LoginPage()),
        GetPage(name: '/home-tutorial', page: () => ClientHomeTutorialPage()),
        GetPage(name: '/trade', page: () => TradeHomePage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/roles', page: () => RolesPage()),
        GetPage(name: '/restaurant/orders/list', page: () => RestaurantOrdersListPage()),
        GetPage(name: '/restaurant/orders/detail', page: () => RestaurantOrdersDetailPage()),
        GetPage(name: '/delivery/orders/list', page: () => DeliveryOrdersListPage()),
        GetPage(name: '/delivery/home', page: () => DeliveryHomePage()),
        GetPage(name: '/delivery/orders/detail', page: () => DeliveryOrdersDetailPage()),
        GetPage(name: '/restaurant/home', page: () => RestaurantHomePage()),
        GetPage(name: '/client/address/list', page: () => ClientAddressListPage()),
        GetPage(name: '/client/address/create', page: () => ClientAddressCreatePage()),
        GetPage(name: '/client/address/list', page: () => ClientAddressListPage()),
        GetPage(name: '/client/home', page: () => ClientHomePage()),
        GetPage(name: '/client/orders/create', page: () => ClientOrdersCreatePage()),
        GetPage(name: '/client/orders/detail',page: () => ClientOrdersDetailPage()),      
        GetPage(name: '/client/payments/installments',page: () => ClientPaymentsInstallmentsPage()),
        GetPage(name: '/client/products/list', page: () => ClientProductsListPage()),
        GetPage(name: '/client/profile/info', page: () => ClientProductsListPage()),
        GetPage(name: '/client/profile/update', page: () => ClientProfileUpdatePage()),
        GetPage(name: '/restaurant/products/list', page: () => RestaurantProductsListPage()),
        GetPage(name: '/restaurant/products/create', page: () => RestaurantProductsCreatePage()),              
      ],
      theme: ThemeData(
        primaryColor: const Color(0xffF2F2F2),
        colorScheme: const ColorScheme(
          primary: Color(0xffF2F2F2),
          secondary: Colors.black,
          brightness: Brightness.light,
          onPrimary: Colors.grey,
          surface: Colors.white,
          onSurface: Colors.grey,
          error: Colors.grey,
          onError: Colors.grey,
          onSecondary: Colors.grey
        )
      ),
      navigatorKey: Get.key,
    );
  }
}