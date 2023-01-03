import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mirukuru/core/resources/core_resource.dart';
import 'package:mirukuru/core/secure_storage/share_preferences.dart';
import 'package:mirukuru/core/util/core_util.dart';
import 'package:mirukuru/core/util/generate_route.dart';
import 'package:mirukuru/core/util/logger_util.dart';

class FirebaseMessageHelper {
  FirebaseMessageHelper._internal();

  static final FirebaseMessageHelper instance =
      FirebaseMessageHelper._internal();
  factory FirebaseMessageHelper() {
    return instance;
  }
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'jp.mlkl.mirukuru',
    'Mirukuru',
    channelDescription: 'Mirukuru notifications',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    icon: '@drawable/ic_stat_notifications_none',
    color: ResourceColors.myPageBackgroundColor,
  );

  Future<void> refreshToken() async {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      Logging.log.info("new token");
      Logging.log.info(newToken);
      await BaseStorage.instance.setStringValue('tokenPushId', newToken);
    });
  }

  Future<void> firebaseConfigNotification() async {
    await FirebaseMessageHelper.instance.getFcmToken();
    refreshToken();
    subscribeTopic();
    registerNotification();
    handleNotificationForeground();
    handleInitialMessage();
    handleAfterOpenedApp();
  }

  void subscribeTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic("myTopic");
  }

  void setupShowAlertFireBase() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future getFcmToken() async {
    return FirebaseMessaging.instance.getToken().then((token) async {
      Logging.log.info("Token: $token");
      await BaseStorage.instance.setStringValue('tokenPushId', token ?? '');
    });
  }

  void handleNotificationForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      Logging.log.info('Got a message in the foreground!');
      const iOSNotificationDetails = IOSNotificationDetails();
      NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails, iOS: iOSNotificationDetails);
      var data = message.data;
      if (message.data.isNotEmpty) {
        Logging.log.info(data);
        flutterLocalNotificationsPlugin.show(
            data.hashCode, data["title"], "", notificationDetails,
            payload: data["title"]);
      } else {
        Logging.log.info("Cannot get message data");
      }
    });
  }

  void handleInitialMessage() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      Logging.log.info(message?.data);
      if (message != null) {
        print('TERMINATED');
        RouteGenerator.navigatorKey.currentState!.pushNamed('/informListPage');
      }
    });
  }

  Future<void> registerNotification() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
      '@drawable/ic_stat_notifications_none',
    );

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: ((payload) {
      print('payload=');
      String? payload = notificationAppLaunchDetails!.payload;
      print(payload);
      if (payload != null) {
        Logging.log.info(payload);
      }

      RouteGenerator.navigatorKey.currentState!.pushNamed('/informListPage');
    }));
  }

  void handleAfterOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Logging.log.info('Got a message open app!');
      Logging.log.info(message.data);
      RouteGenerator.navigatorKey.currentState!.pushNamed('/informListPage');
    });
  }

  Future<bool> checkPermission(BuildContext context) async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      return true;
    }
    return false;
  }

  void requestPermission(BuildContext context) async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
}
