import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings androidInitializationSettings
      = const AndroidInitializationSettings('app_icon');  

    var iosInitializationSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {}
    );

    var initializationSettings = InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);

    await notificationsPlugin.initialize(initializationSettings);
  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName', importance: Importance.high),
      iOS: DarwinNotificationDetails()
    );
  }

  Future showNotification ({int id = 0, String? title, String? body , String? payLoad }) async {
    return notificationsPlugin.show(id, title, body, await notificationDetails());
  }

  Future<void> scheduleNotification({int id = 0, String? title, String? body, String? payload, required tz.TZDateTime notificationDateTime, required BuildContext context}) async {
    
    notificationsPlugin
      .zonedSchedule(id,
                      title,
                      body,
                      notificationDateTime,
                      await notificationDetails(),
                      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);

    var notifications = await notificationsPlugin.pendingNotificationRequests();
    notifications.forEach((element) {
      log('''id [${element.id}], title[${element.title}], body [${element.body}]''');
    });
    return;
  }

  Future<void> removeScheduledNotification(int id) async {
    notificationsPlugin.cancel(id);
    var notifications = await notificationsPlugin.pendingNotificationRequests();
    notifications.forEach((element) {
      log('''id [${element.id}], title[${element.title}], body [${element.body}]''');
    });
    return;
  }
}
