import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  final items = List<String>.generate(20, (i) => "Item ${i + 1}");
  Map title = {};

  @override
  Widget build(BuildContext context) {

    title = ModalRoute.of(context).settings.arguments;
    Color indicator = Colors.red[200];

    //Creates the list of expiry items
    Widget list() {
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          //Testing indicator colours
          indicator = indicator == Colors.red[200] ? Colors.green[200] : Colors.red[200];

          //A removable list item
          return Dismissible(
            key: Key(item),
            //The direction: swipe left to remove
            direction: DismissDirection.endToStart,
            //Removes item when dismissed
            onDismissed: (direction) {
              setState(() {
                items.removeAt(index);
              });
            },
            //The list item's content
            child: ColoredBox(
              color: indicator,
              child: ListTile(
                title: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Icon(Icons.fastfood),
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Food",
                              style: TextStyle(
                                fontSize:20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //Item quantity
                            Text(
                              "Quantity X",
                              style: TextStyle(
                                fontSize:20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(Icons.face),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: <Widget>[
                            Text(
                              "0",
                              style: TextStyle(
                                fontSize:30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("Days Left"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            background: Container(
              color: Colors.orange,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 15.0),
                    child: Icon(
                      Icons.delete,
                    ),
                  )
                ]
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Page title and back button
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 40.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Marquee(
                          text: title["category"],
                          blankSpace: 80.0,
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            size: 40.0,
                            color: Colors.black,
                          ),
                          label: Text(""),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 40.0),
                  //The search field
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          //Change the search variable when typing
                          onChanged: (String val) async {
                            setState(() {
                              //search = val;
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
                                //_controller.clear();
                                //Clear search on click
                                setState(() {
                                  //search = "";
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
                            Navigator.pop(context, 1);
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
              //Adds the list of removable items from the list
              Expanded(
                flex: 7,
                child: items.isNotEmpty ? list() :
                Center(
                  child: Text(
                    "There are no ${title["category"]} in your inventory",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
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
