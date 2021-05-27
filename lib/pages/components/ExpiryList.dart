import 'package:best_before_app/components/ExpiryItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:flutter_sticky_header/flutter_sticky_header.dart";

import 'package:best_before_app/UpdateDatabase.dart';

typedef Callback(bool hide);

class ExpiryList extends StatefulWidget {
  String search;

  ExpiryList({ Key key, this.search }): super(key: key);

  @override
  _ExpiryListState createState() => _ExpiryListState();
}

class _ExpiryListState extends State<ExpiryList> {

  @override
  Widget build(BuildContext context) {
    //Scrollable page
    // productStream();
    Widget expired = DataList(upper: -1, lower: -1000000, search: widget.search, notice:"No Expired Items", header: "Expired Items");
    Widget today = DataList(upper: 0, lower: 0, search: widget.search, notice: "No Items Going Off Today", header: "Today");
    Widget tomorrow = DataList(upper: 1, lower: 1, search: widget.search, notice: "No Items Going Off Tomorrow", header: "Tomorrow");
    Widget fiveDays = DataList(upper: 5, lower: 2, search: widget.search, notice: "No Items Going Off in 5 Days", header: "Next 5 Days");
    Widget sevenDays = DataList(upper: 7, lower: 6, search: widget.search, notice: "No Items Going Off in 7 Days", header: "Next 7 Days");
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: Stack(
          children: <Widget>[
            //This is required for the SliverStickyHeader
            CustomScrollView(
              //The StickyHeaders
              slivers: <Widget>[
                expired,
                today,
                tomorrow,
                fiveDays,
                sevenDays
              ],
            ),
            //Positions the Quantity text to the right
            //of the page so that it is constantly visible
            Align(
              alignment: Alignment.topRight,
              child: Text(
                "Quantity",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ]
      ),
    );
  }
}

class DataList extends StatelessWidget {
  final int upper;
  final int lower;
  final String search;
  final String notice;
  final String header;

  List<Widget> itemWidgets = [];

  //The upper and lower date range and the search value
  DataList({ this.upper, this.lower, this.search, this.notice, this.header});

  bool get empty {
    itemWidgets.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    //Listens for changes from the users databse of items
    //(items added / removed etc)
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection(userCol).snapshots(),
      builder: (context, snapshot) {
        itemWidgets = [];
        //WHen data is gotten creates a list of expiry item widgets
        //Checks if data returned
        if(snapshot.hasData) {
          //Gets a list of the documents
          final items = snapshot.data.docs;

          DateTime now = DateTime.now();
          //Loops through the documents
          for(var item in items) {
            //Gets the document data
            final itemData = item.data();
            //Gets the fields (ExpiryDate, ProductName, Category and quantity)
            final itemExpiry = itemData['ExpiryDate'];
            DateTime expiry = DateTime.parse(itemExpiry);
            //Calculates the days till expiry
            int daysTillExpiry = expiry.difference(DateTime(now.year, now.month, now.day)).inDays;
            //Checks if the expiry date is in the range
            if(daysTillExpiry <= upper && daysTillExpiry >= lower) {
              final itemName = itemData['ProductName'].toString();
              //Check if user is searching or not
              if(search != null) {
                //Checks if the product name contains the search term
                if(itemName.toLowerCase().contains(search.toLowerCase()) || search == "") {
                  //Converts the quantity to an integer
                  var itemQuantity = int.parse(itemData['Quantity'].toString());
                  //Creates the expiry item widget and adds it to the list of widgets
                  final itemWidget = ExpiryItem(product: itemName,quantity: itemQuantity,expiryDate: daysTillExpiry,
                    callback: (remove) {
                      updateItemAmount(item.id, remove, itemQuantity, -1);
                    }
                  );
                  itemWidgets.add(itemWidget);
                }
              }else {
                var itemQuantity = int.parse(itemData['Quantity'].toString());
                final itemWidget = ExpiryItem(product: itemName,quantity: itemQuantity,expiryDate: daysTillExpiry,
                  callback: (remove) {
                    updateItemAmount(item.id, remove, itemQuantity, -1);
                  }
                );
                itemWidgets.add(itemWidget);
              }
            }
          }
        }
        // if(itemWidgets.isEmpty) {
        //   itemWidgets.add(Padding(
        //     padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
        //     child: Text(
        //       this.notice,
        //       style: TextStyle(
        //         fontSize: 20.0,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     )
        //   ));
        // }
        // return Column(
        //   children: itemWidgets,
        // );
        return SliverStickyHeader(
          //ColoredBox is more efficient then container with color property
          header: ColoredBox(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: itemWidgets.isNotEmpty,
                  child: Text(
                    header,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //Button to remove all expired items
                Visibility(
                  visible: upper == -1 && itemWidgets.isNotEmpty,
                  child: TextButton(
                    onPressed: () {
                      removeExpired();
                    },
                    child: Text(
                      "Remove All",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          sliver: SliverList(
            //The content associated with a StickyHeader
            delegate: SliverChildListDelegate(
              [Visibility(
                visible: itemWidgets.isNotEmpty,
                child: Column(
                  children: itemWidgets,
                )
              )]
            )
          ),
        );
      }
    );
  }
}
