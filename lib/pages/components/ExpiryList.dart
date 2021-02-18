import 'package:flutter/material.dart';
import "package:best_before_app/components/ExpiryItem.dart";

class ExpiryList extends StatefulWidget {
  String search;
  ExpiryList({ Key key, this.search }): super(key: key);

  @override
  _ExpiryListState createState() => _ExpiryListState();
}


class _ExpiryListState extends State<ExpiryList> {

  @override
  Widget build(BuildContext context) {
    //List of dummy data items
    List items = CalculateItems().getItems(widget.search);
    //Scrollable page
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Title
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
                  ),
                ),
              ],
            ),
            //Today's expiring items list
            Container(
              child: Column(
                children: items[0].length > 0 ? items[0] : <Widget>[Text("Good, Nothing is going off!")],
              ),
            ),
            //Expiring next 5 days title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Next 5 Days",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            //Expiring next five days list
            Container(
              child: Column(
                children: items[1].length > 0 ? items[1] : <Widget>[Text("Good, Nothing is going off!")],
              ),
            ),
            //Expiring next 7 days title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Next 7 Days",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            //Expiring next 7 days list
            Container(
              child: Column(
                children: items[2].length > 0 ? items[2] : <Widget>[Text("Good, Nothing is going off!")],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalculateItems {
  List<List> getItems(String itemName) {
    List<ExpiryItem> expiryItems = [
      ExpiryItem(expiryDate: 0, product: "Whole Chicken", quantity: 10),
      ExpiryItem(expiryDate: 0, product: "Cheese", quantity: 13),
      ExpiryItem(expiryDate: 0, product: "Venison", quantity: 5),
      ExpiryItem(expiryDate: 0, product: "Pork", quantity: 7),
      ExpiryItem(expiryDate: 4, product: "Corn", quantity: 15),
      ExpiryItem(expiryDate: 4, product: "McNuggets", quantity: 1500),
      ExpiryItem(expiryDate: 4, product: "Whole Chicken", quantity: 10),
      ExpiryItem(expiryDate: 4, product: "Cheese", quantity: 13),
      ExpiryItem(expiryDate: 7, product: "Venison", quantity: 5),
      ExpiryItem(expiryDate: 7, product: "Pork", quantity: 7),
      ExpiryItem(expiryDate: 7, product: "Corn", quantity: 15),
      ExpiryItem(expiryDate: 7, product: "McNuggets", quantity: 1500),
    ];
    List<ExpiryItem> today = [];
    List<ExpiryItem> days5 = [];
    List<ExpiryItem> days7 = [];

    for(ExpiryItem item in expiryItems) {
      if(itemName == null || item.product.toLowerCase().contains(itemName)) {
        if(item.expiryDate == 0) {
          today.add(item);
        }else if(item.expiryDate <= 5) {
          days5.add(item);
        }else if(item.expiryDate <= 7) {
          days7.add(item);
        }
      }
    }
    return [today, days5, days7];
  }
}
