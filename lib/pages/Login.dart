import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/material.dart';
import '../components/menu.dart';
import '../main.dart';
import 'components/sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import "package:best_before_app/UpdateDatabase.dart";
import 'package:firebase_messaging/firebase_messaging.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  bool isLoggedIn = false;
  bool showSpinner = false;

  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });
  }

  @override
  void initState() {
    super.initState();

    var initializationSettingsAndroid = AndroidInitializationSettings('icon');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    //Called while our app is in the foreground for message handling
    //Contains message title and body from server side
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(notification.hashCode, notification.title, notification.body,
        NotificationDetails(
          //assigns specific channel
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',
          ),
        ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      print('New onmessageopenedapp event published');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text("Test"),
              content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.body)
                ],
              ),
            ),
          );
        });
      }
    });

    getToken();
    isSignedIn();
  }

  void isSignedIn() async {
    setState(() {
      loading = true;
    });

    isLoggedIn = await googleSignIn.isSignedIn();

    if (isLoggedIn) {
      userCol = googleSignIn.currentUser.id;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Menu()));
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Colors.amber[500],
                Colors.amber[800],
              ],
            )
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage('assets/icon.png'), height: 225),
                SizedBox(height: 50),
                SignInButton(
                  Buttons.Google,
                  text: "Continue with Google",
                  onPressed: () {
                    setState(() {
                      showSpinner = true;
                    });
                    signInWithGoogle().then((result) {
                      if (result != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return Menu();
                            },
                          ),
                        );
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    });
                  },
                ),
                SizedBox(height: 30),
                SignInButton(
                  Buttons.Email,
                  text: "The Test User",
                  onPressed: () {
                    signInTestUser();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return Menu();
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Used to acquire the device token on loading of the page and is called after the super.init
  getToken() async {
    String token = await FirebaseMessaging.instance.getToken();
    print("This is the token"+token);
  }
}
