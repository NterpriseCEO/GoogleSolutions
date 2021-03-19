import 'dart:async';
import 'package:flutter/material.dart';
import "package:best_before_app/components/InventoryCard.dart";

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

  List<Widget> inventoryCards;

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
    if(inventoryCards == null) {
      inventoryCards = [
        InventoryCard(
          category: "Vegetables",
          goToPage: (int page) {
            widget.goToPage(page);
          },
        ),
        InventoryCard(
          category: "Fruit",
          goToPage: (int page) {
            widget.goToPage(page);
          },
        ),
        InventoryCard(
          category: "Dairy",
          goToPage: (int page) {
            widget.goToPage(page);
          },
        ),
        InventoryCard(
          category: "Sauces",
          goToPage: (int page) {
            widget.goToPage(page);
          },
        ),
        InventoryCard(
          category: "Bread",
          goToPage: (int page) {
            widget.goToPage(page);
          },
        ),
        InventoryCard(
          category: "Meat",
          goToPage: (int page) {
            widget.goToPage(page);
          },
        ),
        InventoryCard(
          category: "Home Cooked Meals",
          goToPage: (int page) {
            widget.goToPage(page);
          },
        ),
      ];
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "My Fridge",
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      search = "";
                      //TODO: code for properly adding a new category
                      inventoryCards.add(InventoryCard(
                        category: "U Wot M8?"
                      ));
                      toEnd();
                    });
                  },
                  label: Text(""),
                  //The the "+" icon
                  icon: Icon(
                    Icons.add,
                    size: 45.0,
                    color: Colors.amber[800],
                  ),
                ),
              ],
            ),
          ),
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
  //If search result is not null, filter cards,
  //otherwise return all cards
  if(query != null) {
    for(InventoryCard item in inventoryCards) {
      //Checks if the search query matches any title cards
      if(item.category.toLowerCase().contains(query)) {
        items.add(item);
      }
    }
    return items;
  }else {
    return inventoryCards;
  }
}

