import 'package:best_before_app/components/InventoryCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../UpdateDatabase.dart';
import 'components/ExpiryChart.dart';

enum LegendShape { Circle, Rectangle }

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Widget> inventoryCards = [];

  Map<String, double> dataMap = {
    "Consumed": 76,
    "Wasted": 24,
  };

  List<Color> colorList = [
    Colors.blue,
    Colors.red,
  ];

  int expiredAmount = 0;
  int total = 0;

  @override
  void initState() {
    super.initState();
    expiredAmount = 0;
    total = 0;
  }

  Future<int> getCards() async {
    List<String> categories = [
      "Vegetables",
      "Fruit",
      "Dairy",
      "Beverages",
      "Sauces",
      "Bread",
      "Meat",
      "Seafood",
      "Pasta",
      "Snacks",
      "Desserts",
      "Homemade Meals",
      "NA",
      "Misc",
      "NA"
    ];
    DateTime d = DateTime.now();

    for (String category in categories) {
      List<int> expired = await CalculateData(category);
      //print("expired yo ${expired[0]}");
      inventoryCards?.add(
          InventoryCard(
            category: category,
            isBreakdownCard: true,
            expiredAmount: expired[0]
          )
      );
      total += expired[1];
      expiredAmount += expired[2];
    }
    return 1;
  }

  int key = 0;

  @override
  Widget build(BuildContext context) {
    //text element for food facts
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: FutureBuilder<int>(
          future: getCards(),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    expandedHeight: MediaQuery.of(context).size.width,
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back,
                      size: 36, color: Colors.black),
                      tooltip: 'Return to Inventory',
                      onPressed: () {
                        Navigator.pop(context);
                      }
                    ),
                    stretch: true,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.symmetric(vertical: 10.0),
                      centerTitle: true,
                      title: Text(
                        "Wastage",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 34.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      background: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: [
                          Text(
                            "Do Not Remove",
                            style: TextStyle(
                              color: Colors.transparent,
                            ),
                          ),
                          ExpiryChart(
                            expiredAmount: 1.0 * expiredAmount,
                            total: 1.0 * total
                          ),
                        ]),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverGrid.count(
                      crossAxisCount: 3,
                      children: [
                        inventoryCards[0],
                        inventoryCards[1],
                        inventoryCards[2],
                        inventoryCards[3],
                        inventoryCards[4],
                        inventoryCards[5],
                        inventoryCards[6],
                        inventoryCards[7],
                        inventoryCards[8],
                        inventoryCards[9],
                        inventoryCards[10],
                        inventoryCards[11],
                        inventoryCards[12],
                        inventoryCards[13],
                        inventoryCards[14],
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                      child: Text(
                    "Loading...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36.0,
                    ),
                  ))
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
