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
  TextEditingController _controller;
  ScrollController _scrollController;

  List<Widget> inventoryCards = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    _scrollController = new ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              "Weekly Breakdown",
              style: TextStyle(
                fontSize: 34.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //The scrollable list of cards
          // Expanded(
          //   flex: 9,
          //   child: showCategories(search, inventoryCards, _scrollController)
          // ),
          Expanded(
            flex: 9,
            child: categoriesList(),
          ),
        ],
      ),
    );
  }
  Widget categoriesList() {
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
            for(String category in categories.keys) {
              print("test ${categories[category]}");
              inventoryCards?.add(InventoryCard(
                category: category,
                isBreakdownCard: true,
                expiredAmount: categories[category]
              ));
            }
            return GridView.count(
              crossAxisCount: 2,
              children: inventoryCards,
              controller: _scrollController,
            );
          }else {
            return Container();
          }
        }
      );
    }else {
      return GridView.count(
        crossAxisCount: 2,
        children: inventoryCards,
        controller: _scrollController,
      );
    }
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

List<Widget> filterCards(String query, List<Widget> inventoryCards) {
  List<Widget> items = [];
  print(inventoryCards);
  //If search result is not null, filter cards,
  //otherwise return all cards
  if(query != null) {
    for(InventoryCard item in inventoryCards) {
      //Checks if the search query matches any title cards
      if(item.category.toLowerCase().contains(query)) {
        items.add(item);
      }
    }
    if(items.isEmpty) {
      items.add(Column(
        children: [
          Text(
            "No category found",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize:20.0,
            ),
          ),
          Image(image: AssetImage("assets/icon.png"))
        ])
      );
    }
    return items;
  }else {
    return inventoryCards;
  }
}

