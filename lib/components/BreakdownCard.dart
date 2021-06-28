import 'package:flutter/material.dart';

class BreakdownCard extends StatelessWidget {
  final String product;
  final int quantity;
  final int expiryCount;
  //The callback for removing the item from the inventory

  BreakdownCard({this.quantity, this.product, this.expiryCount,});

  @override
  Widget build(BuildContext context) {
    //Set the expiry date to 0 if it is less than 0

    //The colour indicator for how fresh an item is
    return ListTile(
      title: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              this.product,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold
              )
            ),
            SizedBox(height: 10.0),
            Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                  height: 30.0,
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: this.expiryCount/this.quantity,
                      heightFactor: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(7.5),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 30.0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        ((this.expiryCount/this.quantity)*100).toString()+"%",
                        style: TextStyle(
                          color: Colors.white
                        )
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
