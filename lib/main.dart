import 'dart:async';
import 'dart:developer';
import 'package:filechat/api/apis.dart';
import 'package:filechat/screens/call_screen.dart';
import 'package:filechat/screens/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//global object for accessing device screen size
late Size mq;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    _initializeFirebase();
    initializeNotifications(flutterLocalNotificationsPlugin);
    configureNotifications(flutterLocalNotificationsPlugin);
    runApp(const MyApp());
  });
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  _playRingtone();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  print("####################################");
  APIs.markCallAsRinged(message.data['call_id']);
  initializeNotifications(flutterLocalNotificationsPlugin);
  showCallNotification(flutterLocalNotificationsPlugin, message);
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
const platform = MethodChannel('com.example.filechat/ringtone');
Timer? _timer;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        title: 'We Chat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal, fontSize: 19),
          backgroundColor: Colors.white,
        )),
        home: const SplashScreen());
  }
}

_initializeFirebase() async {
  print("---------------------------");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('Permission granted: ${settings.authorizationStatus}');
  messaging.getToken().then((token) {
    print("Device Token: $token");
  });
}

void initializeNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  var result = await FlutterNotificationChannel().registerNotificationChannel(
      description: 'For Showing Message Notification',
      id: 'chats',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'Chats');

  log('\nNotification Channel Result: $result');
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid, iOS: null);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
    if (notificationResponse.payload != null) {
      // Handle the action here based on payload
      if (notificationResponse.actionId == 'accept_action') {
        final data = await APIs.getCallData(notificationResponse.payload!);
        try {
          _stopRingtone();
        } catch (e) {
          print(e);
        }
        navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (context) {
            return CallScreen(
                data: data, callId: notificationResponse.payload!);
          },
        ));
      } else if (notificationResponse.actionId == 'decline_action') {
        _stopRingtone();
        await APIs.markCallAsRinged(notificationResponse.payload!);
      }
      print('Notification payload: ${notificationResponse.payload}');
    }
  });
}

void configureNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  var androidPlatformChannelSpecifics = const AndroidNotificationChannel(
    'your_channel_id',
    'your_channel_name',
    description: 'your_channel_description',
    importance: Importance.max,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidPlatformChannelSpecifics);
}

void showCallNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    RemoteMessage message) {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'call_channel',
    'Incoming Call',
    channelDescription: 'Channel for incoming call notifications',
    importance: Importance.max,
    priority: Priority.high,
    fullScreenIntent: true,
    actions: <AndroidNotificationAction>[
      AndroidNotificationAction('accept_action', 'Accept'),
      AndroidNotificationAction('decline_action', 'Decline'),
    ],
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
    payload: message.data['call_id'],
  );
}

Future<void> _playRingtone() async {
  try {
    _startTimer();
    await platform.invokeMethod('playRingtone');
  } on PlatformException catch (e) {
    print("Failed to play ringtone: '${e.message}'.");
  }
}

Future<void> _stopRingtone() async {
  try {
    await platform.invokeMethod('stopRingtone');
  } on PlatformException catch (e) {
    print("Failed to stop ringtone: '${e.message}'.");
  }
}

void _startTimer() {
  _timer = Timer(Duration(seconds: 30), () {
    _stopRingtone();
  });
}
