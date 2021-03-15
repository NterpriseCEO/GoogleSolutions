//import 'dart:async';
//import 'dart:io';
//import 'dart:typed_data';
//import 'dart:ui';

//import 'package:device_info/device_info.dart';
import 'dart:math';

import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:http/http.dart' as http;
//import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

var now;
var zone;

void initNotifications() async {
  //START OF IMPORTANT MESSAGE: Don't modify this code unless you want to give yourself an aneurysm //////////////////////////////////////////////////////
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //init plugin. app_icon needs to be added as drawable resource to android head project

  final NotificationAppLaunchDetails notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  //Also don't ask me what this does, it is a ReactJS thing...
  final BehaviorSubject<ReceivedNotification> didReceiveNotificationSubject = BehaviorSubject<ReceivedNotification>();
  final BehaviorSubject<String> selectedNotificationSubject = BehaviorSubject<String>();

  String currentTimeZone  = await FlutterNativeTimezone.getLocalTimezone();
  await tz.initializeTimeZones();
  zone = tz.getLocation(currentTimeZone);
  now = await tz.TZDateTime.now(zone);

  String selectedNotificationPayload;
  if(notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
  }

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("meat");
  final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: (int id, String title, String body, String payload) async {
        didReceiveNotificationSubject.add(ReceivedNotification(
          id: id, title: title, body: body, payload: payload,
        ));
      }
  );

  final MacOSInitializationSettings initializationSettingsMacOS = MacOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
    macOS: initializationSettingsMacOS,
  );
  //END OF IMPORTANT MESSAGE/////////////////////////////////////////////////////////////////////////////////

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String payload) async {
      if(payload != null) {
        debugPrint("notification payload: $payload");
      }
      selectedNotificationPayload = payload;
      selectedNotificationSubject.add(payload);
    }
  );
}

var rand = Random();

Future<void> notification(String product, int quantity, int expiry) async {
  //print("hello: ${tz.getLocation(currentTimeZone)}");
  now = await tz.TZDateTime.now(zone);
  if(expiry > 0) {
    flutterLocalNotificationsPlugin.zonedSchedule(
        rand.nextInt(pow(2, 31) - 1),
        "$product has gone off!!!",
        "You let $quantity $product go off dipshit!!!",
        now.add(Duration(days  : expiry)),
        const NotificationDetails(
          android: AndroidNotificationDetails("0", "fuck you", "bitch"),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
  }
}