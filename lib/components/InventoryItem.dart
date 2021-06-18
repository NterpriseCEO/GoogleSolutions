import 'package:flutter/material.dart';

typedef void Callback(int direction);

class InventoryItem extends StatelessWidget {
  int expiryDate;
  final String product;
  final int quantity;
  //The callback for removing the item from the inventory
  final Callback callback;

  InventoryItem({this.expiryDate, this.product, this.quantity, @required this.callback});

  @override
  Widget build(BuildContext context) {
    //Set the expiry date to 0 if it is less than 0
    expiryDate = expiryDate < 0 ? 0 : expiryDate;

    //The colour indicator for how fresh an item is
    Color indicator = Colors.green[200];
    if(expiryDate <= 1) {
      indicator = Colors.red[200];
    }else if(expiryDate <= 2) {
      indicator = Colors.orange[200];
    }
    return ColoredBox(
      color: indicator,//indicator,
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //Buttons to hide elements
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.exposure_minus_1),
                      onPressed: () {
                        this.callback(-1);
                      }
                    ),
                    IconButton(
                      icon: Icon(Icons.add_sharp),
                      onPressed: () {
                        this.callback(1);
                      }
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //The item name
                    Text(
                      "$product",
                      style: TextStyle(
                        fontSize:20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //Item quantity
                    Text(
                      "Quantity: $quantity",
                      style: TextStyle(
                        fontSize:20.0,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    //The item expiry date
                    Text(
                      "$expiryDate",
                      style: TextStyle(
                        fontSize:30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Days Left",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
