import 'dart:async';
import 'package:flutter/material.dart';
import "package:best_before_app/components/menu.dart";
import "package:best_before_app/pages/Inventory.dart";
import 'notifications/LocalNotifications.dart';
import "package:best_before_app/pages/Login.dart";
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initNotifications();

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
