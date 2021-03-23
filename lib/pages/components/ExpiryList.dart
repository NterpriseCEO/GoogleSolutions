// import 'dart:html';
// import 'dart:js';
// import 'dart:js';

import 'package:best_before_app/components/ExpiryItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:flutter_sticky_header/flutter_sticky_header.dart";

import 'package:best_before_app/UpdateDatabase.dart';

typedef Callback(bool hide);

class EmptyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: Text(
          "Good, Nothing is going off!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize:20.0,
          )
        ),
      ),
    );
  }
}

/*Widget dataList(int days1, int days2, String search, Callback isVisible)  {
  return
}*/

class ExpiryList extends StatefulWidget {
  String search;

  ExpiryList({ Key key, this.search }): super(key: key);

  @override
  _ExpiryListState createState() => _ExpiryListState();
}

class _ExpiryListState extends State<ExpiryList> {

  bool goneOff = true;
  bool today = true;
  bool tomorrow = true;
  bool fiveDays = true;
  bool sevenDays = true;

  List<String> expired = [""];

  @override
  Widget build(BuildContext context) {

    print(widget.search);

    //Scrollable page
    // productStream();
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: Stack(
        children: <Widget>[
          //This is required for the SliverStickyHeader
          CustomScrollView(
            //The StickyHeaders
            slivers: <Widget>[
              //StickyHeader / content combo
              SliverStickyHeader(
                //ColoredBox is more efficient then container with color property
                header: ColoredBox(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expired items',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          removeExpired();
                        },
                        child: Text("Remove all"),
                      ),
                    ],
                  ),
                ),
                sliver: SliverList(
                  //The content associated with a StickyHeader
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      DataList(upper: -1, lower: -1000000, search: widget.search, isVisible: (bool visible) {
                        if(!visible) {
                          today = false;
                        }else {
                          today = true;
                        }
                      })
                    ]
                  )
                ),
              ),
              SliverStickyHeader(
                //ColoredBox is more efficient then container with color property
                header: ColoredBox(
                  color: Colors.white,
                  child: Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                sliver: SliverList(
                  //The content associated with a StickyHeader
                  delegate: SliverChildListDelegate.fixed(
                    //Checks if there are items going off today, prints message if not
                    <Widget>[
                      DataList(upper: 0, lower: 0, search: widget.search, isVisible: (bool visible) {
                        if(!visible) {
                          today = false;
                        }else {
                          today = true;
                        }
                      })
                    ]
                  ),
                ),
              ),
              SliverStickyHeader(
                header: ColoredBox(
                  color: Colors.white,
                  child: Text(
                    'Tomorrow',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    //Checks if there are items going off tomorrow, prints message if not
                    <Widget>[
                      DataList(upper: 1, lower: 1, search: widget.search, isVisible: (bool visible) {
                        if(!visible) {
                          tomorrow = false;
                        }else {
                          tomorrow = true;
                        }
                      })
                    ]
                  ),
                ),
              ),
              SliverStickyHeader(
                header: ColoredBox(
                  color: Colors.white,
                  child: Text(
                    'Next 5 Days',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    //Checks if there are items going off in 5 days, prints message if not
                    <Widget>[DataList(upper: 5, lower: 2, search: widget.search, isVisible: (bool visible) {
                      if(!visible) {
                        fiveDays = false;
                      }else {
                        fiveDays = true;
                      }
                    })]
                  ),
                ),
              ),
              SliverStickyHeader(
                header: ColoredBox(
                  color: Colors.white,
                  child: Text(
                    'Next 7 Days',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                sliver: SliverList(
                  //Checks if there are items going off in 7 days, prints message if not
                  delegate: SliverChildListDelegate.fixed(
                    <Widget>[
                      DataList(upper: 7, lower: 6, search: widget.search, isVisible: (bool visible) {
                        if(!visible) {
                          sevenDays = false;
                        }else {
                          sevenDays = true;
                        }
                      })
                    ]
                  ),
                ),
              ),
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
  final Callback isVisible;

  DataList({ this.upper, this.lower, this.search, this.isVisible });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection(userCol).snapshots(),
      builder: (context, snapshot) {
        List<Widget> itemWidgets = [];
        if(snapshot.hasData) {
          final items = snapshot.data.docs;

          int increment = 0;
          DateTime now = DateTime.now();
          for(var item in items){
            final itemData = item.data();
            final itemExpiry = itemData['ExpiryDate'];
            DateTime expiry = DateTime.parse(itemExpiry);
            int daysTillExpiry = expiry.difference(DateTime(now.year, now.month, now.day)).inDays;
            if(daysTillExpiry <= upper && daysTillExpiry >= lower) {
              final itemName = itemData['ProductName'].toString();
              if(search != null) {
                if(itemName.toLowerCase().contains(search.toLowerCase()) || search == "") {
                  increment++;
                  var itemQuantity = int.parse(itemData['Quantity'].toString());
                  final itemWidget = ExpiryItem(product: itemName,quantity: itemQuantity,expiryDate: daysTillExpiry,
                    callback: (remove) {
                      updateItemAmount(item.id, remove, itemQuantity, -1);
                    }
                  );
                  itemWidgets.add(itemWidget);
                }
              }else {
                increment++;
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
          if(increment == 0) {
            //itemWidgets.add(EmptyList());
            isVisible(false);
          }
        }
        return Column(
          children: itemWidgets,
        );
      }
    );
  }
}

