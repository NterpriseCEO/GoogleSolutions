import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/material.dart';

import 'components/sign_in.dart';
import '../components/menu.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.amber[800],
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage('assets/icon.png'), height: 225),
              SizedBox(height: 50),
              ElevatedButton(
                child: Text("Sign Out"),
                onPressed: () {
                  signOutGoogle();
                  Navigator.pushNamed(context, "/Login");
                },
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
