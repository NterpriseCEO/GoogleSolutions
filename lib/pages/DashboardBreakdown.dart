import 'package:best_before_app/components/InventoryItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../UpdateDatabase.dart';

class DashboardBreakdown extends StatefulWidget {
  @override
  _DashboardBreakdownState createState() => _DashboardBreakdownState();
}

class _DashboardBreakdownState extends State<DashboardBreakdown> {

  Map category = {};

  @override
  Widget build(BuildContext context) {

    category = ModalRoute.of(context).settings.arguments;

    firestore.collection("expiryGroups").doc("Users").collection(userCol)
    .where("Category", isEqualTo: category["category"]).get()
    .then((snapshot) {
      List<DocumentSnapshot> docs = snapshot.docs;
      docs.forEach((DocumentSnapshot document) {
        print("hello mate! ${document.get("Category")}");
      });
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
          size: 36, color: Colors.black),
          tooltip: 'Return to Inventory',
          onPressed: () {
            Navigator.pop(context);
          }
        ),
        centerTitle: true,
        title: Text(
          "Expiration",
          style: TextStyle(
            color: Colors.black,
            fontSize: 34.0
          )
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:  firestore.collection("expiryGroups").doc("Users").collection(userCol)
            .where("Category", isEqualTo: category["category"]).get().asStream(),
        builder: (context, snapshot){
          List<Widget> itemWidgets = [];
          if(snapshot.hasData){
            final items = snapshot.data.docs;

            int increment = 0;
            DateTime now = DateTime.now();
            for(var item in items){
              final itemCategory = item.get('Category');
              if(itemCategory == category["category"]) {
                String itemName = item.get('ProductName').toString();
                int itemQuantity = int.parse(item.get('Quantity').toString());

                increment++;
                final itemWidget = Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  child: InventoryItem(
                    expiryDate: 10,
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
            if(increment == 0) {
              itemWidgets.add(Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                      "No results found!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize:20.0,
                      ),
                    ),
                    Image(image: AssetImage("assets/icon.png")),
                  ]
                ),
              ));
            }
          }
          return ListView(
            children: itemWidgets,
          );
        }
      )
    );
  }
}
