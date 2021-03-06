import 'dart:async';

import "package:best_before_app/components/InventoryCard.dart";
import 'package:flutter/material.dart';

typedef Callback(int pageNumber);

class InventoryOverview extends StatefulWidget {
  final Callback goToPage;

  InventoryOverview({ Key key, @required this.goToPage }): super(key: key);
  @override
  _InventoryOverviewState createState() => _InventoryOverviewState();
}

class _InventoryOverviewState extends State<InventoryOverview> {
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
    if(inventoryCards.isEmpty) {
      List<String> categories = ["Vegetables", "Fruit", "Dairy", "Beverages", "Sauces", "Bread", "Meat", "Seafood", "Pasta", "Snacks", "Desserts", "Homemade Meals", "Misc",];
      for(String category in categories) {
        inventoryCards?.add(InventoryCard(
          category: category,
          isBreakdownCard: false,
          expiredAmount: 0,
        ));
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          iconSize: 40,
          tooltip: 'Dashboard',
          icon: Icon(
            Icons.data_usage,
            color: Colors.amber[600],
            semanticLabel: "Test",
          ),
          onPressed: () {
            Navigator.pushNamed(context, "/Dashboard");
          },
        ),
        centerTitle: true,
        title: Text(
          "My Fridge",
          style: TextStyle(
            color: Colors.black,
            fontSize: 34.0
          )
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
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
            //The scrollable list of cards
            Expanded(
              flex: 9,
              child: showCategories(search, inventoryCards, _scrollController)
            ),
          ],
        ),
      ),
    );
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

