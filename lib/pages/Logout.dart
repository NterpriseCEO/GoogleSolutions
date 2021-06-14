import 'package:flutter/material.dart';

import 'components/sign_in.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
              colors: [
              Colors.amber[500],
              Colors.amber[800],
            ],
          ),
        ),
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
