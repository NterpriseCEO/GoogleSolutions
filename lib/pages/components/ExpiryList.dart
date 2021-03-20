// import 'dart:html';
// import 'dart:js';
// import 'dart:js';

import 'package:best_before_app/components/ExpiryItem.dart';
import 'package:flutter/material.dart';
import "package:best_before_app/globals.dart";
import "package:flutter_sticky_header/flutter_sticky_header.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

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

// void getProducts() async {
//   print('test');
//   var product = firestore.collection('products');
//   var item = await product.get();
//   for(int x = 0; x < item.docs.length; x++)
//     {
//       Map<String, dynamic> data = item.docs[x].data();
//       print('${data['ProductName']} \n ${data['Category']} \n ${data['ExpiryDate']} \n ${data['Quantity']} ');
//     }
// }

// void productStream() async {
//   await for (var snapshot in firestore.collection('products').snapshots()){
//     for (var item in snapshot.docs){
//       var itemData = item.data();
//       var itemCategory = itemData['Category'];
//       var itemName = itemData['ProductName'];
//       var itemQuantity = itemData['Quantity'];
//       var itemExpiry = itemData['ExpiryDate'];
//       print('this is message sender $itemName , $itemCategory, $itemQuantity, $itemExpiry');
//     }
//   }
// }

Widget dataList()  {
   return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('products').snapshots(),
      builder: (context, snapshot){
        List<Widget> itemWidgets = [];
        if(snapshot.hasData){
          final items = snapshot.data.docs;

          for(var item in items){
            final itemData = item.data();
            final itemCategory = itemData['Category'];
            final itemName = itemData['ProductName'];
            final itemQuantity = int.tryParse(itemData['Quantity']);
            final itemExpiry = itemData['ExpiryDate'];
            DateTime expiry = DateTime.parse(itemExpiry);
            int daysTillExpiry = expiry.difference(DateTime.now()).inDays;
            print('this is message sender $itemName , $itemCategory, $itemQuantity, $daysTillExpiry');
            final itemWidget = ExpiryItem(product: itemName,quantity: itemQuantity,expiryDate: daysTillExpiry,);
            itemWidgets.add(itemWidget);
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
    //List of dummy data items
    List items = getItems(widget.search);

    void decrement(ExpiryItemData item, bool remove) {
      setState((){
        item.quantity--;
        if(item.quantity == 0 || remove) {
          removeItem(item);
        }
      });
    }

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
                          visible = false;
                          removeExpired();
                          expired.remove(expired.removeAt(index));
                        });
                      },

                      //List of items that are expired
                      child: dataList(),
                      // child: items[0].length > 0 ? Column(
                      //   children: [
                      //     for(int i = 0; i < items[0].length; i++) ExpiryItem(
                      //       expiryDate: items[0][i].daysTillExpiry,
                      //       product: items[0][i].product,
                      //       quantity: items[0][i].quantity,
                      //       callback: (remove) => decrement(items[0][i], remove),
                      //     ),
                      //   ],
                      // ) : EmptyList(),
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
                    items[1].length > 0 ? [
                      for(int i = 0; i < items[1].length; i++) ExpiryItem(
                        expiryDate: items[1][i].daysTillExpiry,
                        product: items[1][i].product,
                        quantity: items[1][i].quantity,
                        callback: (remove) => decrement(items[1][i], remove),
                      ),
                    ] : [EmptyList()],
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
                    items[2].length > 0 ? [
                      for(int i = 0; i < items[2].length; i++) ExpiryItem(
                        expiryDate: items[2][i].daysTillExpiry,
                        product: items[2][i].product,
                        quantity: items[2][i].quantity,
                        callback: (remove) => decrement(items[2][i], remove),
                      ),
                    ] : [EmptyList()],
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
                    items[3].length > 0 ? [
                      for( int i = 0; i < items[3].length; i++) ExpiryItem(
                        expiryDate: items[3][i].daysTillExpiry,
                        product: items[3][i].product,
                        quantity: items[3][i].quantity,
                        callback: (remove) => decrement(items[3][i], remove),
                      ),
                    ] : [EmptyList()],
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
                    items[4].length > 0 ? [
                      for ( int i = 0; i < items[4].length; i++) ExpiryItem(
                        expiryDate: items[4][i].daysTillExpiry,
                        product: items[4][i].product,
                        quantity: items[4][i].quantity,
                        callback: (remove) => decrement(items[4][i], remove),
                      ),
                    ] : [EmptyList()],
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
