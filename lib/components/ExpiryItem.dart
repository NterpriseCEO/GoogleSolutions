import 'package:flutter/material.dart';

class ExpiryItem extends StatelessWidget {
  String expiryDate;
  String product;
  int quantity;

  ExpiryItem({ this.expiryDate, this.product, this.quantity });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation:0,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child:Text(
                expiryDate,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child:Text(
                product,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child:Text(
                quantity.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
