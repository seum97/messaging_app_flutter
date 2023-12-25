
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {

  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // A stream to listen to the payload when notification is clicked
  static final notificationPayload = BehaviorSubject<String?>();

  // initialize the local notifications
  Future init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      // onDidReceiveBackgroundNotificationResponse: onNotificationTap
    );
  }

  // This function will be executed once notification is clicked
  void onNotificationTap(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      // adding payload to the listener stream
      notificationPayload.add(payload);
    }

  }

  // Request to show notification
  static Future requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.request();
    if (status != PermissionStatus.granted) {
      // Handle the case where the user denied permission
      print('Notification permission denied');
    }
  }


  NotificationDetails notificationDetails()  {
    print("notificationDetails entered");
    return NotificationDetails(
      android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          channelDescription: 'Channel Desc',
          importance: Importance.max
      ),
    );

  }


  // showing Notification using local_notification_package
  Future showLocalNotifications(String title,String body,String payload) async {
    await _flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        notificationDetails(),
        payload: payload
    );
  }


}