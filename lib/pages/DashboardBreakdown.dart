import 'package:best_before_app/components/BreakdownCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../UpdateDatabase.dart';
import 'components/Utils.dart';

class DashboardBreakdown extends StatefulWidget {
  @override
  _DashboardBreakdownState createState() => _DashboardBreakdownState();
}

class _DashboardBreakdownState extends State<DashboardBreakdown> {

  Map category = {};

  @override
  Widget build(BuildContext context) {

    category = ModalRoute.of(context).settings.arguments;

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
          "Expired Items",
          style: TextStyle(
            color: Colors.black,
            fontSize: 34.0
          )
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:  firestore.collection("expiryGroups").doc("Users").collection(userCol)
            .where("Category", isEqualTo: category["category"]).where("week", isEqualTo: weekNumber(DateTime.now())-1).get().asStream(),
        builder: (context, snapshot){
          List<Widget> itemWidgets = [];
          if(snapshot.hasData){
            final items = snapshot.data.docs;

            int increment = 0;
            DateTime now = DateTime.now();
            for(var item in items){
              final itemCategory = item.get('Category');
              String itemName = item.get('ProductName').toString();
              int itemQuantity = int.parse(item.get('Quantity').toString());
              int expiredCount = int.parse(item.get('expiryCount').toString());

              increment++;

              itemWidgets.add(BreakdownCard(
                product: itemName,
                quantity: itemQuantity,
                expiryCount: expiredCount,
              ));
            }
            if(increment == 0) {
              itemWidgets.add(Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                      "No items expired!",
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
