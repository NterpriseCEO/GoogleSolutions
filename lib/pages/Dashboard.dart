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

  String getRandomElement(List li){
    final rand = new Random();
    var i = rand.nextInt(li.length);
    return li[i];
  }
  List facts = [
    "More then 1/3 of all food is wasted. That's around 1.3 billion tonnes a year.",
    "Food waste causes 3.3 billion tonnes of C02 emissions a year.",
    "Almost \$1 trillion in food is wasted globally a year. Don't waste money overbuying.",
    "An area larger then China is used to grow food that is never eaten.",
    "25% of the worlds fresh water is used to grow food that is never eaten.",
    "Food waste would be the 3rd largest emitter of C02 if it were a country.",
    "In developed countries over half of total food waste is in homes rather then in restaurants.",
    "Reducing food wastage is one of the best ways to fight climate change.",
    "Best before dates can still be eaten after the date labelled on the package.",
    "Eat other foods, 75% of food generated is by 12 plants and 5 animal species.",
    "The global food system is responsible for almost 30% of all Green House Gas emissions.",
    "33% of fish stocks are overfished at an unsustainable level leading to decreasing fish populations.",
    "Fruit and Vegetables are the most wasted food group. Accounting for 40-50% together",
    "25% of food waste can feed 870 million people. This would feed the 690 million underfed people.",
    "Food rot from wasted food releases Methane which is 28x stronger then C02.",
    "8% of Green House Gasses are caused by food waste when they rot in landfills.",
    "One burger uses the same amount of water as a 90 minute shower. That's 2400 litres of water.",
    "It takes 25 years for a head of lettuce to decompose in a landfill.",
    "Large amounts of food are wasted due to appearance as people don't want to eat them.",
    "Reducing food waste is the third most effective way to address climate change."
  ];

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
      inventoryCards?.add(InventoryCard(
          category: category,
          isBreakdownCard: true,
          expiredAmount: expired[0]));
      total += expired[1];
      expiredAmount += expired[2];
    }

    return 1;
  }

  int key = 0;

  @override
  Widget build(BuildContext context) {
    //text element for food facts
    var textElement = getRandomElement(facts);
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
                  SliverPadding(
                    padding: EdgeInsets.all(16.0),
                    sliver: SliverToBoxAdapter(
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
                              height: 10.0,
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
                      )
                    ),
                  )
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
