// import 'dart:html';
// import 'dart:js';
// import 'dart:js';

import 'package:best_before_app/components/ExpiryItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:flutter_sticky_header/flutter_sticky_header.dart";

import 'package:best_before_app/UpdateDatabase.dart';

class EmptyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Text(
        "Good, Nothing is going off!",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize:20.0,
        )
      ),
    );
  }
}

Widget dataList(int days1, int days2, String search)  {
  return StreamBuilder<QuerySnapshot>(
    stream: firestore.collection(userCol).snapshots(),
    builder: (context, snapshot) {
      List<Widget> itemWidgets = [];
      if(snapshot.hasData){
        final items = snapshot.data.docs;

        int increment = 0;
        for(var item in items){
          final itemData = item.data();
          final itemExpiry = itemData['ExpiryDate'];
          DateTime expiry = DateTime.parse(itemExpiry);
          int daysTillExpiry = expiry.difference(DateTime.now()).inDays;
          if(daysTillExpiry <= days1 && daysTillExpiry >= days2) {
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
          itemWidgets.add(EmptyList());
        }
      }
      return Column(
      children: itemWidgets,
      );
    }
  );
}

class ExpiryList extends StatefulWidget {
  String search;

  ExpiryList({ Key key, this.search }): super(key: key);

  @override
  _ExpiryListState createState() => _ExpiryListState();
}

class _ExpiryListState extends State<ExpiryList> {

  bool visible = true;
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
                  child: visible ? Text(
                    'Expired items',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ) : null,
                ),
                sliver: SliverList(
                  //The content associated with a StickyHeader
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = expired[index];
                    return Dismissible(
                      key: Key(item),
                      direction: DismissDirection.startToEnd,
                      //Removes item when dismissed
                      onDismissed: (direction) {
                        setState(() {
                          //visible = false;
                          //removeExpired();
                          //expired.remove(expired.removeAt(index));
                        });
                      },

                      //List of items that are expired
                      child: dataList(-1, -1000000, widget.search),
                      background: Container(
                        color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 15.0),
                              child: Icon(
                                Icons.delete,
                              ),
                            )
                          ]
                        ),
                      ),
                    );
                  },childCount: expired.length),
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
                  delegate: SliverChildListDelegate(
                    //Checks if there are items going off today, prints message if not
                    [dataList(0, 0, widget.search)]
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
                  delegate: SliverChildListDelegate(
                    //Checks if there are items going off tomorrow, prints message if not
                    [dataList(1, 1, widget.search)]
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
                  delegate: SliverChildListDelegate(
                    //Checks if there are items going off in 5 days, prints message if not
                    [dataList(5, 2, widget.search)]
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
                  delegate: SliverChildListDelegate(
                    [dataList(7, 6, widget.search)]
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
