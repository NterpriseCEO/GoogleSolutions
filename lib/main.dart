import 'package:flutter/material.dart';
import "package:best_before_app/components/menu.dart";
import "package:best_before_app/pages/Inventory.dart";
import 'notifications/LocalNotifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initNotifications();

  runApp(MaterialApp(
    initialRoute: "/",
    debugShowCheckedModeBanner: false,
    routes: {
      "/": (context) => Menu(),
      "/inventory": (context) => Inventory(),
    },
  ));
}
