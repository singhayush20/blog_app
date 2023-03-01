import 'dart:developer';

import 'package:blog_app/Pages/Home/HomePage.dart';
import 'package:blog_app/Pages/Home/MessageArticlePage.dart';
import 'package:blog_app/constants/Themes.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/Pages/login_and_auth/LoginPage.dart';
import 'package:blog_app/network_util/FCMNotificationUtil.dart';
import 'package:blog_app/provider/CategoryProvider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

late SharedPreferences _sharedPreferences;
bool isLoggedIn = false;
Future<void> _initializePrefs() async {
  log("Loading Shared Preferences");
  _sharedPreferences = await SharedPreferences.getInstance();
  log('Shared Preferences loaded');
  isLoggedIn = _sharedPreferences.getBool(IS_LOGGED_IN) ?? false;
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//  =
// FlutterLocalNotificationsPlugin();

//background handler works in its own isolate, and not part of
//the application therefore, we should keep it out of any context, outside the
//flutter application
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  // showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  log('background message: ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    // 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // /// Update the iOS foreground notification presentation options to allow
  // /// heads up notifications.
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  isFlutterLocalNotificationsInitialized = true;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // if (!kIsWeb) {
  //   await setupFlutterNotifications();
  // }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await _initializePrefs();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _configureForegroundMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotificationService.display(message);
    });
  }

  _handleMessageClickEvent() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _goToArticleScreen(initialMessage.data);
    }

    //if the app is in background (not terminated), but open and user taps on
    //on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      //message.data has key-value pairs
      //we can put a route key to tell which screen to navigate to
      //using named route
      log('app in background: message tapped: ${message.data}');
      //Navigate to the screen
      _goToArticleScreen(message.data);
    });
  }

  void _goToArticleScreen(Map<String, dynamic> messageData) {
    if (_sharedPreferences.getBool(IS_LOGGED_IN) == true) {
      Get.to(() => MessageArticlePage(data: messageData));
    } else {
      Get.to(() => const LoginPage());
    }
  }

  @override
  void initState() {
    super.initState();
    LocalNotificationService.initialize(context); //for foreground notifications

    /*
    If the application has been opened from a terminated state via a [RemoteMessage] (containing a [Notification]), it will be returned, otherwise it will be null.
    Once the [RemoteMessage] has been consumed, it will be removed and further calls to [getInitialMessage] will be null.
    This should be used to determine whether specific notification interaction should open the app with a specific purpose (e.g. opening a chat message, specific screen etc).
    */
    ///Gives the message on which the user taps from terminated state
    // FirebaseMessaging.instance.getInitialMessage().then((message) {
    //   //if we have a message
    //   if (message != null) {
    //     log('App terminated: notification clicked: ${message.data}');
    //     //now we can navigate to a screen
    //     _goToArticleScreen(message.data);
    //   }
    // });

    _configureForegroundMessaging();
    _handleMessageClickEvent();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CategoryProvider.initialze(_sharedPreferences),
        ),
      ],
      child: Sizer(
        builder: ((context, orientation, deviceType) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightThemeData,
            darkTheme: lightThemeData,
            home: (isLoggedIn == false) ? const LoginPage() : const HomePage(),
          );
        }),
      ),
    );
  }
}
