//import 'dart:async';
//import 'dart:io';
//import 'dart:typed_data';
//import 'dart:ui';

//import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:http/http.dart' as http;
//import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
//import 'package:timezone/data/latest.dart' as tz;
//import 'package:timezone/timezone.dart' as tz;

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

void initNotifications() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //init plugin. app_icon needs to be added as drawable resource to android head project

  final NotificationAppLaunchDetails notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  final BehaviorSubject<ReceivedNotification> didReceiveNotificationSubject = BehaviorSubject<ReceivedNotification>();
  final BehaviorSubject<String> selectedNotificationSubject = BehaviorSubject<String>();

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