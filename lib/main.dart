import 'dart:async';
import 'package:flutter/material.dart';
import "package:best_before_app/components/menu.dart";
import "package:best_before_app/pages/Inventory.dart";
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notifications/LocalNotifications.dart';
import "package:best_before_app/pages/Login.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

//Used for handling of firebase messaging
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

//Used for displaying notifications
//Past Android V8 notifications won't be displayed without a channel
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

//Called to show notifications in our device.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initNotifications();

  //Allows for handling of background messages and the await assigns the channel
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(MaterialApp(
    initialRoute: "/Login",
    debugShowCheckedModeBanner: false,
    routes: {
      "/": (context) => Menu(),
      "/Login": (context) => Login(),
      "/inventory": (context) => Inventory(),
    },
  ));
}

