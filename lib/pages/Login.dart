import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/menu.dart';
import 'components/sign_in.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 150),
              SizedBox(height: 50),
              _signInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
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
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.blue[100]),
    );
  }
}

/*

class Login extends StatefulWidget {
  bool obscureText = true;
  IconData passIcon = Icons.remove_red_eye_outlined;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 40.0,
                    ),
                  ),
                ),
                Expanded(
                    flex: 9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Username",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextField(
                          //Change the search variable when typing
                          onChanged: (String val) async {
                            setState(() {
                              //search = val;
                            });
                          },
                          //The input styling
                          decoration: InputDecoration(
                            //Placeholder text
                            hintText: "Username",
                            //The magnifying glass icon
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            //The clear search icon
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                //_controller.clear();
                                //Clear search on click
                                setState(() {
                                  //search = "";
                                });
                              },
                            ),
                            //Background colour = true
                            filled: true,
                            //Background colour
                            fillColor: Colors.grey[300],
                            contentPadding: EdgeInsets.all(0.0),
                            //Border when not focused
                            enabledBorder: OutlineInputBorder(
                              //Border colour
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            //Border when focused
                            focusedBorder: OutlineInputBorder(
                              //Border colour
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextField(
                          onChanged: (String val) async {
                            setState(() {
                              //search = val;
                            });
                          },
                          obscureText: widget.obscureText,
                          enableSuggestions: false,
                          autocorrect: false,
                          //The input styling
                          decoration: InputDecoration(
                            //Placeholder text
                            hintText: "Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            //The clear search icon
                            suffixIcon: IconButton(
                              icon: Icon(widget.passIcon),
                              onPressed: () {
                                //_controller.clear();
                                setState(() {
                                  widget.obscureText = !widget.obscureText;
                                  widget.passIcon = widget.obscureText
                                      ? Icons.remove_red_eye_outlined
                                      : Icons.remove_red_eye;
                                });
                              },
                            ),
                            //Background colour = true
                            filled: true,
                            //Background colour
                            fillColor: Colors.grey[300],
                            contentPadding: EdgeInsets.all(0.0),
                            //Border when not focused
                            enabledBorder: OutlineInputBorder(
                              //Border colour
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            //Border when focused
                            focusedBorder: OutlineInputBorder(
                              //Border colour
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () async {
                                await Navigator.pushNamed(context, "/");
                              },
                              child: Text("Signup"),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await Navigator.pushNamed(context, "/");
                              },
                              child: Text("Login"),
                            ),
                          ],
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

*/
