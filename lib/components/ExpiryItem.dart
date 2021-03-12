import 'package:flutter/material.dart';

typedef void Callback();

//Data for the expiry items
class ExpiryItemData {
  final int expiryDate;
  final String product;
  final int quantity;

  ExpiryItemData({this.expiryDate, this.product, this.quantity });
}

class ExpiryItem extends StatelessWidget {
  MaterialColor expiryStatus = Colors.green;

  final int expiryDate;
  final String product;
  final int quantity;

  final Callback callback;

  ExpiryItem({this.expiryDate, this.product, this.quantity, @required this.callback });

  @override
  Widget build(BuildContext context) {

    //Sets the circle colour based on expiry dates
    if(this.expiryDate < 2) {
      expiryStatus = Colors.red;
    }else if(this.expiryDate <= 5) {
      expiryStatus = Colors.orange;
    }

    return Card(
      elevation:0,
      child: ListTile(
        //Product name and quantity
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Text(
                this.product,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize:20.0,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                width:60.0,
                child: Text(
                  this.quantity.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:20.0,
                  ),
                ),
              ),
            ),
          ],
        ),
        //Removes the padding from the ListTitle
        contentPadding: EdgeInsets.all(0.0),
        //The colour ring icon
        leading: TextButton(
          onPressed: () {
            this.callback();
          },
          child: CircleAvatar(
            radius: 22,
            backgroundColor: expiryStatus,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
            ),
          ),
        ),
      ),
    );
  }
}

