import 'package:flutter/material.dart';

class ExpiryItem extends StatelessWidget {
  final int expiryDate;
  final String product;
  final int quantity;
  MaterialColor expiryStatus = Colors.green;

  ExpiryItem({ this.expiryDate, this.product, this.quantity });

  @override
  Widget build(BuildContext context) {

    if(expiryDate < 2) {
      expiryStatus = Colors.red;
    }else if(expiryDate <= 5) {
      expiryStatus = Colors.orange;
    }

    return Card(
      elevation:0,
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(product),
            Container(
              width:60.0,
              child: Text(
                quantity.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        contentPadding: EdgeInsets.all(0.0),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: expiryStatus,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 15,
          ),
        ),
      ),
      /*child: Padding(
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
      ),*/
    );
  }
}
