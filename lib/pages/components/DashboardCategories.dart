import "package:best_before_app/UpdateDatabase.dart";
import "package:best_before_app/components/InventoryCard.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardCategories extends StatefulWidget {

  DashboardCategories();
  @override
  _DashboardCategoriesState createState() => _DashboardCategoriesState();
}

class _DashboardCategoriesState extends State<DashboardCategories> {
  String search;
  ScrollController _scrollController;

  List<Widget> inventoryCards = [];

  @override
  void initState() {
    super.initState();

    _scrollController = new ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    if(inventoryCards.isEmpty) {
      Map<String, int> categories = {
        "Vegetables": 0,
        "Fruit": 0,
        "Dairy": 0,
        "Beverages": 0,
        "Sauces": 0,
        "Bread": 0,
        "Meat": 0,
        "Seafood": 0,
        "Pasta": 0,
        "Snacks": 0,
        "Desserts": 0,
        "Homemade Meals": 0,
        "Misc": 0
      };
      DateTime d = DateTime.now();
      DateTime first = DateTime(d.year, d.month, d.day);
      int weekDay = d.weekday;
      var firstDayOfWeek = first.subtract(Duration(days: weekDay));

      for(String category in categories.keys) {
        print("test ${categories[category]}");
        inventoryCards?.add(InventoryCard(
            category: category,
            isBreakdownCard: true,
            expiredAmount: categories[category]
        ));
        print(inventoryCards);
      }

      return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection(userCol).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            final items = snapshot.data.docs;

            //Loops through the documents
            for(var item in items) {
              //Gets the document data
              //Gets the fields (ExpiryDate, ProductName, Category and quantity)
              final itemExpiry = item.get('ExpiryDate');
              DateTime expiry = DateTime.parse(itemExpiry);
              //Calculates the days till expiry
              if(expiry.isAfter(firstDayOfWeek) && expiry.isBefore(DateTime.now())) {
                categories[item.get("Category")]++;
                print("Helllo");
              }
            }
            for(InventoryCard card in inventoryCards) {
              card.expiredAmount = categories[card.category];
              print("testing now ${card.expiredAmount}");
            }
            print("Hello motherfucker $inventoryCards");
            return SliverGrid.count(
              crossAxisCount: 2,
              children: inventoryCards,
            );
          }else {
            return SliverGrid.count(
              crossAxisCount: 2,
              children: inventoryCards,
            );
          }
        }
      );
    }else {
      return SliverGrid.count(
        crossAxisCount: 2,
        children: inventoryCards,
      );
    }
  }
  Widget categoriesList() {
    print(inventoryCards.isEmpty);
  }
}

Widget showCategories(String query, List<Widget> inventoryCards, ScrollController _scrollController) {
  List<Widget> items = [];

  if(query != null) {
    for(InventoryCard item in inventoryCards) {
      //Checks if the search query matches any title cards
      if(item.category.toLowerCase().contains(query)) {
        items.add(item);
      }
    }
  }else {
    items.addAll(inventoryCards);
  }
  if(items.isNotEmpty || query == null || query == "") {
    return GridView.count(
      crossAxisCount: 2,
      children: items,
      controller: _scrollController,
    );
  }else {
    return Column(
      children: [
        Text(
          "No category found",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize:20.0,
          ),
        ),
        Image(image: AssetImage("assets/icon.png")),
      ]
    );
  }
}

