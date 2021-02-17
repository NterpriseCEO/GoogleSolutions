import 'package:flutter/material.dart';
import "package:best_before_app/components/menu.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Menu(),
  ));
}
