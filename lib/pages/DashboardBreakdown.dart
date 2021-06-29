import 'dart:math';

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

  String getRandomElement(List li){
    final rand = new Random();
    var i = rand.nextInt(li.length);
    return li[i];
  }
  List facts = [
    "More then 1/3 of all food is wasted. That's around 1.3 billion tonnes a year.",
    //"Food waste causes 3.3 billion tonnes of C02 emissions a year.",
    "Almost \$1 trillion in food is wasted globally a year. Don't waste money overbuying.",
    "An area larger then China is used to grow food that is never eaten.",
    "25% of the worlds fresh water is used to grow food that is never eaten.",
    //"Food waste would be the 3rd largest emitter of C02 if it were a country.",
    //"In developed countries over half of total food waste is in homes rather then in restaurants.",
    //"Reducing food wastage is one of the best ways to fight climate change.",
    //"Best before dates can still be eaten after the date labelled on the package.",
    //"Eat other foods, 75% of food generated is by 12 plants and 5 animal species.",
    //"The global food system is responsible for almost 30% of all Green House Gas emissions.",
    //"33% of fish stocks are overfished at an unsustainable level leading to decreasing fish populations.",
    "Fruit and Vegetables are the most wasted food group. Accounting for 40-50% together",
    //"25% of food waste can feed 870 million people. This would feed the 690 million underfed people.",
    //"Food rot from wasted food releases Methane which is 28x stronger then C02.",
    //"8% of Green House Gasses are caused by food waste when they rot in landfills.",
    "One burger uses the same amount of water as a 90 minute shower. That's 2400 litres of water.",
    "It takes 25 years for a head of lettuce to decompose in a landfill.",
    "Large amounts of food are wasted due to appearance as people don't want to eat them.",
    //"Reducing food waste is the third most effective way to address climate change."
  ];

  @override
  Widget build(BuildContext context) {

    category = ModalRoute.of(context).settings.arguments;

    String textElement = getRandomElement(facts);

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
        stream: firestore.collection("expiryGroups").doc("Users").collection(userCol)
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
            itemWidgets.add(
              Column(
                children: <Widget>[
                  Text(
                    "Food Facts",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Colors.amber[500],
                            Colors.amber[500],
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 1.0,
                          ),
                          Text(
                            textElement,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              height: 1.5,
                              fontSize: 17.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            );
          }
          return ListView(
            children: itemWidgets,
          );
        }
      )
    );
  }
}
