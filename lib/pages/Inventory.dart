import 'dart:math';

import 'package:best_before_app/UpdateDatabase.dart';
import 'package:best_before_app/components/ExpiryItem.dart';
import 'package:best_before_app/components/InventoryItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  Map title = {};

  TextEditingController _controller;

  String search = "";

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    title = ModalRoute.of(context).settings.arguments;

    //Creates the list of expiry items
    Widget dataList()  {
      return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection(userCol).snapshots(),
        builder: (context, snapshot){
          List<Widget> itemWidgets = [];
          if(snapshot.hasData){
            final items = snapshot.data.docs;

            int increment = 0;

            for(var item in items){
              final itemData = item.data();
              final itemCategory = itemData['Category'];
              if(itemCategory == title["category"]) {
                final itemExpiry = itemData['ExpiryDate'];
                DateTime expiry = DateTime.parse(itemExpiry);
                int daysTillExpiry = expiry.difference(DateTime.now()).inDays;
                String itemName = itemData['ProductName'].toString();
                int itemQuantity = int.parse(itemData['Quantity'].toString());

                if(itemName.toLowerCase().contains(search.toLowerCase()) || search == "") {
                  increment++;
                  final itemWidget = Dismissible(
                    key: UniqueKey(),
                    child: InventoryItem(
                      expiryDate: daysTillExpiry,
                      product: itemName,
                      quantity: itemQuantity,
                      callback: (int direction) {
                        updateItemAmount(item.id, false, itemQuantity, direction);
                      },
                    ),
                    onDismissed: (direction) {
                      updateItemAmount(item.id, true, itemQuantity, 0);
                    },
                    background: Container(
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 15.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          )
                        ]
                      ),
                    ),
                  );
                  itemWidgets.add(itemWidget);
                }
              }
            }
            if(increment == 0) {
              itemWidgets.add(Center(
                child: Text(
                  "There's no ${title["category"]} in your inventory",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ));
            }
          }
          return Column(
            children: itemWidgets,
          );
        }
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Page title and back button
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 40.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Text(
                          title["category"],
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context, 1);
                          },
                          label: Text(""),
                          icon: Icon(
                            Icons.add,
                            size: 45.0,
                            color: Colors.amber[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  //The search field
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _controller,
                          //Change the search variable when typing
                          onChanged: (String val) async {
                            setState(() {
                              search = val;
                            });
                          },
                          //The input styling
                          decoration: InputDecoration(
                            //Placeholder text
                            hintText: "Search",
                            //The magnifying glass icon
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            //The clear search icon
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                _controller.clear();
                                //Clear search on click
                                setState(() {
                                  search = "";
                                });
                              },
                            ),
                            //Background colour = true
                            filled: true,
                            //Background colour
                            fillColor: Colors.grey[300],
                            contentPadding: EdgeInsets.all(0.0),
                            //Border when not focused
                            enabledBorder: OutlineInputBorder(
                              //Border colour
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            //Border when focused
                            focusedBorder: OutlineInputBorder(
                              //Border colour
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //Adds the list of removable items from the list
              Expanded(
                flex: 7,
                child: dataList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
