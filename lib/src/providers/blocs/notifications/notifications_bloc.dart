// import 'dart:math';

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:micelio/src/providers/localnotification/local_notification.dart';
// import 'package:micelio/src/providers/preferences/pref_usuarios.dart';

// part 'notifications_event.dart';
// part 'notifications_state.dart';

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   Random random = Random();
//   var id = random.nextInt(100000);
//   var mensaje = message.data;
//   var body = mensaje['body'];
//   var title = mensaje['title'];    

//   LocalNotification.showLocalNotification(
//     id: id,
//     title: title,
//     body: body
//   );
// }

// class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  
//   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   NotificationsBloc() : super(NotificationsInitial()) {
//     _onForegroundMessage();
//   }

//   void requestPermission(BuildContext context) async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: true,
//       provisional: false,
//       sound: true
//     );

//     // Pasar el contexto al método que lo necesite
//     await LocalNotification.requestPermissionLocalNotifications();
//     settings.authorizationStatus;
//     getToken();
//   }

//   void getToken() async {
//     final settings = await messaging.getNotificationSettings();
//     if (settings.authorizationStatus != AuthorizationStatus.authorized) return;

//     final token = await messaging.getToken();
//     print(token);
//     if (token != null) {
//       final prefs = PreferenciasUsuario();
//       prefs.token = token;
//     }
//   }

//   void _onForegroundMessage() {
//     FirebaseMessaging.onMessage.listen(handleRemoteMessage);
//   }

//   void handleRemoteMessage(RemoteMessage message) {
//     Random random = Random();
//     var id = random.nextInt(100000);
//     var mensaje = message.data;
//     var body = mensaje['body'];
//     var title = mensaje['title'];    

//     LocalNotification.showLocalNotification(
//       id: id,
//       title: title,
//       body: body
//     );
//   }
// }
