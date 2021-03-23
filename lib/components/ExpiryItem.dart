import 'package:flutter/material.dart';

typedef void Callback(bool remove);

//Data for the expiry items
class ExpiryItemData {
  final DateTime expiryDate;
  int daysTillExpiry = 0;
  final String product;
  int quantity;
  String category;

  ExpiryItemData({this.expiryDate, this.product, this.quantity, this.daysTillExpiry, this.category });
}

class ExpiryItem extends StatelessWidget {
  MaterialColor expiryStatus = Colors.green;

  final int expiryDate;
  final String product;
  final int quantity;
  //The callback for removing the item from the inventory
  final Callback callback;

  ExpiryItem({this.expiryDate, this.product, this.quantity, @required this.callback });

  @override
  Widget build(BuildContext context) {

    //Sets the circle colour based on expiry dates
    if(this.expiryDate < 0) {
      expiryStatus = Colors.red;
    }else if(this.expiryDate <= 2) {
      expiryStatus = Colors.orange;
    }

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        this.callback(true);
      },
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
        leading: ElevatedButton(
          child: Text(
            "-",
            style: TextStyle(
              fontSize:40,
            )
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: expiryStatus,
            shape: CircleBorder(),
          ),
          onPressed: () {
            this.callback(false);
          },
        ),
      ),
      //The delete icon that appears behind the dismissible widget
      background: Container(
        color: Colors.red,
        child: Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

