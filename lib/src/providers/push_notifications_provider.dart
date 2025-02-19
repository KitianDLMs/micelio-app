// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:micelio/src/providers/users_provider.dart';

// class PushNotificationsProvider {
//   static FirebaseMessaging messaging = FirebaseMessaging.instance;
//   static String? token;

//   static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> _backgroundHandler(RemoteMessage message) async {
//     // print('onBackgroundHandler ${message.notification!.title}');
//     _showNotification(message);
//   }

//   static Future<void> _onMessageHandler(RemoteMessage message) async {
//     // print('onMessageHandler ${message.messageId}');
//     _showNotification(message);
//   }

//   static Future<void> _onOpenMessageOpenApp(RemoteMessage message) async {
//     // print('onOpenMessageOpenApp ${message.messageId}');
//   }

//   static Future<void> initializeApp() async {
//      // Inicializa Firebase
//      await Firebase.initializeApp();
//      token = await FirebaseMessaging.instance.getToken();
//     //  print('TOKEN -> $token');

//      // Configura los handlers
//      FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
//      FirebaseMessaging.onMessage.listen(_onMessageHandler);
//      FirebaseMessaging.onMessageOpenedApp.listen(_onOpenMessageOpenApp);

//      // Configura las notificaciones locales
//      const AndroidInitializationSettings initializationSettingsAndroid =
//          AndroidInitializationSettings('@mipmap/ic_launcher');
//      const InitializationSettings initializationSettings = InitializationSettings(
//        android: initializationSettingsAndroid,
//      );
//      await _localNotificationsPlugin.initialize(initializationSettings);

//     //  print('Notificaciones locales configuradas');
//    }

//    static void _showNotification(RemoteMessage message) async {
//      RemoteNotification? notification = await message.notification;
//      AndroidNotification? android = await message.notification?.android;
//      // print('Notification ${notification!.android!.channelId!}');
//      // print('android ${android!.channelId}');    
//      if (notification != null) {
//        const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//          'default_channel', // ID del canal (debe coincidir con el configurado en MainActivity)
//          'Default Channel', // Nombre del canal
//          channelDescription: 'Canal predeterminado para mostrar notificaciones',
//          importance: Importance.max,
//          priority: Priority.high,
//          playSound: true,
//        );

//        const NotificationDetails platformDetails = NotificationDetails(
//          android: androidDetails,
//        );

//        // Mostrar la notificación
//        await _localNotificationsPlugin.show(
//          notification.hashCode, // ID único
//          notification.title, // Título
//          notification.body, // Cuerpo
//          platformDetails,
//        );
//      }
//    }

//    void saveToken(String idUser) async {
//     String? token = await FirebaseMessaging.instance.getToken();
//     UsersProvider usersProvider = UsersProvider();
//     if (token != null) {
//       await usersProvider.updateNotificationToken(idUser, token);
//     }
//   }
//  }
