import 'package:flutter/material.dart';

class ExpiryItem extends StatelessWidget {
  int expiryDate;
  String product;
  int quantity;

  ExpiryItem({ this.expiryDate, this.product, this.quantity });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation:0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child:Text(
                expiryDate.toString(),
              ),
            ),
            Expanded(
              flex: 4,
              child:Text(
                product,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child:Text(
                quantity.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
