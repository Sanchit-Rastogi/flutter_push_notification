import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:push_notification/services/utils.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotifyService {
  static final _notify = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    final bigPicturePath = await Utils.downloadFile(
      "https://www.digitaland.tv/wp-content/uploads/2016/08/1.jpg",
      'bigPicture',
    );
    final largeIconPath = await Utils.downloadFile(
      'https://freeiconshop.com/wp-content/uploads/edd/notification-flat.png',
      'largeIcon',
    );

    final styleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicturePath),
        largeIcon: FilePathAndroidBitmap(largeIconPath));

    final sound = 'bell.wav';

    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id 1',
        'channel name',
        'channel discription',
        importance: Importance.max,
        styleInformation: styleInformation,
        sound: RawResourceAndroidNotificationSound(sound.split('.').first),
        enableVibration: true,
      ),
      iOS: IOSNotificationDetails(
        sound: sound,
      ),
    );
  }

  static Future init() async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = IOSInitializationSettings();
    final settings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    //To navigate to a screen when app is closed
    final details = await _notify.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      onNotification.add(details.payload);
    }

    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));

    await _notify.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotification.add(payload);
      },
    );
  }

  static Future showNotification({
    int id = 1,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notify.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );

  static Future showSecheduledNotification({
    int id = 1,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledTime,
  }) async =>
      _notify.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
}
