import "package:flutter/material.dart";
import "package:best_before_app/pages/components/ExpiryList.dart";

class ExpirationPage extends StatefulWidget {
  @override
  _ExpirationPageState createState() => _ExpirationPageState();
}

class _ExpirationPageState extends State<ExpirationPage> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                "Expiration",
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    filled: true,
                    fillColor: Colors.grey[300],
                    contentPadding: EdgeInsets.all(0.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: ExpiryList(),
            ),
          ),
        ],
      ),
    );
  }
}
