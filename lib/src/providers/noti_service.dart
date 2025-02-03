import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotiService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // INITIALIZE 
  Future<void> initNotification() async {
    if (_isInitialized) return; // prevent re-initialization

    // prepare android init settiongs 
    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
    
    // prepare ios init settiongs 
    const initSettiongsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // init settiongs 
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettiongsIOS
    );

    // finally, initialize the plugin!
    await notificationPlugin.initialize(initSettings);
  }

  // NOTIFICATIONS DETAIL SETUP 
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id', 
        'Daily Notifications', 
        channelDescription: 'Daily Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
        // icon: '@mipmap-hdpi/ic_launcher'
      ),
      iOS: DarwinNotificationDetails(

      )
    );
  }

  // SHOWNOTIFICATION
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    final details = notificationDetails();
    return notificationPlugin.show(
      id, 
      title, 
      body, 
      const NotificationDetails(android: AndroidNotificationDetails(
        'daily_channel_id', 
        'Daily Notifications', 
        channelDescription: 'Daily Notification Channel',
        importance: Importance.max,
        priority: Priority.high
      ))
    );
  }

  // ON NOTI TAP
  Future<void> onTapNotification() async {
    
  }
}