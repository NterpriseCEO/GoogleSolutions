import 'package:flutter/material.dart';
import "package:best_before_app/components/ExpiryItem.dart";

// SingleChildScrollView(
// child: Column(
// children: <Widget>[
//
// ],
// ),
// ),

class ExpiryList extends StatefulWidget {
  @override
  _ExpiryListState createState() => _ExpiryListState();
}

class _ExpiryListState extends State<ExpiryList> {
  List<ExpiryItem> expiryItems = [
    ExpiryItem(expiryDate: "10/10/2020", product: "Whole Chicken", quantity: 10),
    ExpiryItem(expiryDate: "11/11/2020", product: "Cheese", quantity: 13),
    ExpiryItem(expiryDate: "12/12/2020", product: "Venison", quantity: 5),
    ExpiryItem(expiryDate: "23/10/2021", product: "Pork", quantity: 7),
    ExpiryItem(expiryDate: "05/12/2030", product: "Corn", quantity: 15),
    ExpiryItem(expiryDate: "13/10/2090", product: "McNuggets", quantity: 1500),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  )
                ),
                Text(
                    "Quantity",
                    style: TextStyle(
                      fontSize: 20.0,
                    )
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Container(
              child: Column(
                children: expiryItems.length > 0 ? expiryItems : <Widget>[Text("Good, Nothing is going off!")],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
