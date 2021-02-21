import 'package:flutter/material.dart';

class InventoryCard extends StatelessWidget {
  String category;
  InventoryCard({ this.category });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("test");
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(
            color: Colors.orange,
            width:2.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                  flex: 4,
                  child: Image.asset("assets/vegetables.png"),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  category,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize:20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class InventoryOverview extends StatefulWidget {
  @override
  _InventoryOverviewState createState() => _InventoryOverviewState();
}

class _InventoryOverviewState extends State<InventoryOverview> {
  String search;
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                      onPressed: (){},
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
              children: <Widget>[
                InventoryCard(category: "Vegetables"),
                InventoryCard(category: "Fruits"),
                InventoryCard(category: "Dairy"),
                InventoryCard(category: "Sauces"),
                InventoryCard(category: "Breads"),
                InventoryCard(category: "Meat"),
                InventoryCard(category: "Home Cooked Meals"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

