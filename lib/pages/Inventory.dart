
import 'package:best_before_app/UpdateDatabase.dart';
import 'package:best_before_app/components/InventoryItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  Map category = {};

  TextEditingController _controller;

  String search = "";

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

    category = ModalRoute.of(context).settings.arguments;

    //Creates the list of expiry items
    Widget dataList()  {
      return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection(userCol).where("Category", isEqualTo: category["category"]).snapshots(),
        builder: (context, snapshot){
          List<Widget> itemWidgets = [];
          if(snapshot.hasData){
            final items = snapshot.data.docs;

            int increment = 0;
            DateTime now = DateTime.now();
            for(var item in items){
              final itemExpiry = item.get('ExpiryDate');
              DateTime expiry = DateTime.parse(itemExpiry);
              int daysTillExpiry = expiry.difference(DateTime(now.year, now.month, now.day)).inDays;
              String itemName = item.get('ProductName').toString();
              int itemQuantity = int.parse(item.get('Quantity').toString());

              if(itemName.toLowerCase().contains(search.toLowerCase()) || search == "") {
                increment++;
                final itemWidget = Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  child: InventoryItem(
                    expiryDate: daysTillExpiry,
                    product: itemName,
                    quantity: itemQuantity,
                    callback: (int direction) {
                      updateItemAmount(item.id, false, itemQuantity, direction);
                    },
                  ),
                  onDismissed: (direction) {
                    updateItemAmount(item.id, true, itemQuantity, 0);
                  },
                  background: Container(
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 15.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        )
                      ]
                    ),
                  ),
                );
                itemWidgets.add(itemWidget);
              }
            }
            if(increment == 0) {
              itemWidgets.add(Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                      (search == null || search == "") ?
                      "There's no ${category["category"].toLowerCase()} in your inventory" :
                      "No results found!",
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
          }
          return ListView(
            children: itemWidgets,
          );
        }
      );
    }

    // Expanded(
    //   flex: 1,
    //   child: TextButton.icon(
    //     onPressed: () {
    //       Navigator.pop(context, 1);
    //     },
    //     label: Text(""),
    //     icon: Icon(
    //       Icons.add,
    //       size: 45.0,
    //       color: Colors.amber[800],
    //     ),
    //   ),
    // ),

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          category["category"],
          style: TextStyle(
            color: Colors.black,
            fontSize: 34.0
          )
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            //Page title and back button
            SizedBox(height: 10.0),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            ),
            //Adds the list of removable items from the list
            Expanded(
              flex: 8,
              child: dataList(),
            ),
          ],
        ),
      ),
    );
  }
}
