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
    expiryDate = expiryDate < 0 ? 0 : expiryDate;
    Color indicator = Colors.green[200];
    if(expiryDate <= 0) {
      indicator = Colors.red[200];
    }else if(expiryDate <= 2) {
      indicator = Colors.orange[200];
    }
    return ColoredBox(
      color: indicator,//indicator,
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                  )
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
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
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Text(
                      "$expiryDate",
                      style: TextStyle(
                        fontSize:30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Days Left"),
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
