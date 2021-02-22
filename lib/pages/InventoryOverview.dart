import 'dart:async';
import 'package:flutter/material.dart';
import "package:best_before_app/components/InventoryCard.dart";

class InventoryOverview extends StatefulWidget {
  @override
  _InventoryOverviewState createState() => _InventoryOverviewState();
}

class _InventoryOverviewState extends State<InventoryOverview> {
  String search;
  TextEditingController _controller;
  ScrollController _scrollController;

  List<Widget> inventoryCards = [
    InventoryCard(category: "Vegetables"),
    InventoryCard(category: "Fruits"),
    InventoryCard(category: "Dairy"),
    InventoryCard(category: "Sauces"),
    InventoryCard(category: "Breads"),
    InventoryCard(category: "Meat"),
    InventoryCard(category: "Home Cooked Meals"),
  ];

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

  void toEnd() {
    Timer(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              "My Inventory",
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              //The search field
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
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
                  Expanded(
                    flex: 1,
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          search = "";
                          inventoryCards.add(InventoryCard(category: "U Wot M8?"));
                          toEnd();
                        });
                      },
                      icon: Icon(
                        Icons.add,
                        size: 45.0,
                        color: Colors.amber[800],
                      ),
                      label: Text(""),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: GridView.count(
              crossAxisCount: 2,
              children: filterCards(search?.toLowerCase(), inventoryCards),
              controller: _scrollController,
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> filterCards(String query, List<Widget> inventoryCards) {
  List<Widget> items = [];
  print(inventoryCards);
  if(query != null) {
    for(InventoryCard item in inventoryCards) {
      if(item.category.toLowerCase().contains(query)) {
        items.add(item);
      }
    }
    return items;
  }else {
    return inventoryCards;
  }
}

