import 'package:flutter/material.dart';

class ExpiryItem extends StatelessWidget {
  final int expiryDate;
  final String product;
  final int quantity;
  MaterialColor expiryStatus = Colors.green;

  ExpiryItem({ this.expiryDate, this.product, this.quantity });

  @override
  Widget build(BuildContext context) {

    //Sets the circle colour based on expiry dates
    if(expiryDate < 2) {
      expiryStatus = Colors.red;
    }else if(expiryDate <= 5) {
      expiryStatus = Colors.orange;
    }

    return Card(
      elevation:0,
      child: ListTile(
        //Product name and quantity
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              product,
              style: TextStyle(
                fontSize:20.0,
              ),
            ),
            Container(
              width:60.0,
              child: Text(
                quantity.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:20.0,
                ),
              ),
            ),
          ],
        ),
        //Removes the padding from the ListTitle
        contentPadding: EdgeInsets.all(0.0),
        //The colour ring icon
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: expiryStatus,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 15,
          ),
        ),
      ),
    );
  }
}
