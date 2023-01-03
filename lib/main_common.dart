import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mirukuru/core/resources/resources.dart';
import 'package:mirukuru/core/util/firebase_message_helper.dart';
import 'package:mirukuru/core/util/logger_util.dart';
import 'package:mirukuru/core/util/version_utils/version_utils.dart';
import 'package:mirukuru/features/app_bloc/app_bloc.dart';
import 'package:mirukuru/core/util/generate_route.dart';
import 'core/config/app_properties.dart';
import 'injection_container.dart' as di;
import 'package:firebase_core/firebase_core.dart';

Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  Logging.log.info('On background message:');
  Logging.log.info('Message title: ${message.data["title"] ?? ''}');
  const iOSNotificationDetails = IOSNotificationDetails();
  const AndroidNotificationDetails androidNotificationDetails =
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
  NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails, iOS: iOSNotificationDetails);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var data = message.data;
  if (message.data.isNotEmpty) {
    Logging.log.info(data);
    flutterLocalNotificationsPlugin.show(
        data.hashCode, data["title"], "", notificationDetails,
        payload: data["title"]);
  } else {
    Logging.log.info("Cannot get message data");
  }
}

Future<void> mainCommon(AppProperties config) async {
  AppProperties.instance = config;

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDmLcBmf4gvP2WEB22Q8wvhphQ0MLT5XRo",
          projectId: "mirukuru-25e02",
          storageBucket: "mirukuru-25e02.appspot.com",
          messagingSenderId: "325093841383",
          appId: "1:325093841383:ios:baf8fa694b7842ec148542"),
    );
  } else if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyA3TR8MKFqeHgtLMyzsEIFHAAS1meqXlVA",
          projectId: "mirukuru-25e02",
          storageBucket: "mirukuru-25e02.appspot.com",
          messagingSenderId: "325093841383",
          appId: "1:325093841383:android:5de927d334e497c5148542"),
    );
  }
  await di.init();
  await VersionUtils(remoteConfig: FirebaseRemoteConfig.instance)
      .initFirebaseRemoteConfig();
  await VersionUtils.instance.clearBeforeCheckUpdate();
  configDeviceOrientation();
  runApp(EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('ja', 'JP')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: MyApp()));
  configLoading();
  await FirebaseMessageHelper.instance.firebaseConfigNotification();
  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

void configDeviceOrientation() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc(),
      child: MaterialApp(
        title: 'Mirukuru App', navigatorKey: RouteGenerator.navigatorKey,
        theme: ThemeData(
          primaryColor: Colors.green.shade800,
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: Colors.green.shade600),
        ),
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        //home: NumberTriviaPage(),
        onGenerateRoute: RouteGenerator.generateRoute,
        builder: EasyLoading.init(builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        }),
      ),
    );
  }
}
