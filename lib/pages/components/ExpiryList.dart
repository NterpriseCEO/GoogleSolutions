import 'package:best_before_app/UpdateDatabase.dart';
import 'package:best_before_app/components/ExpiryItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:flutter_sticky_header/flutter_sticky_header.dart";

//Counter of how many items have gone off on a specific day
int total = 0;
String day;

typedef Callback(bool hide);

class ExpiryList extends StatefulWidget {
  String search;

  ExpiryList({ Key key, this.search }): super(key: key);

  @override
  _ExpiryListState createState() => _ExpiryListState();
}

class _ExpiryListState extends State<ExpiryList> {
  //work
  @override
  Widget build(BuildContext context) {
    //Scrollable page
    // productStream();
    // Widget expired = DataList(upper: -1, lower: -1000000, search: widget.search, notice:"No Expired Items", header: "Expired Items");
    // Widget today = DataList(upper: 0, lower: 0, search: widget.search, notice: "No Items Going Off Today", header: "Today");
    // Widget tomorrow = DataList(upper: 1, lower: 1, search: widget.search, notice: "No Items Going Off Tomorrow", header: "Tomorrow");
    // Widget fiveDays = DataList(upper: 5, lower: 2, search: widget.search, notice: "No Items Going Off in 5 Days", header: "Next 5 Days");
    // Widget sevenDays = DataList(upper: 7, lower: 6, search: widget.search, notice: "No Items Going Off in 7 Days", header: "Next 7 Days");

    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: DataList(search: widget.search, notice: "hello", header: "header"),
    );
  }
}

class DataList extends StatefulWidget {
  final String search;
  final String notice;
  final String header;


  DataList({this.search, this.notice, this.header});

  @override
  _DataListState createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  List<Widget> expired = [];

  List<Widget> today = [];

  List<Widget> tomorrow = [];

  List<Widget> fiveDays = [];

  List<Widget> sevenDays = [];

  int counter = 0;

  bool noItems = false;

  bool results = true;

  int deleteAmount = 0;

  String prevSearch = "";

  SliverStickyHeader createSliverHeader(List<Widget> items, String header, bool isExpired) {
    return SliverStickyHeader(
      //ColoredBox is more efficient then container with color property
      header: ColoredBox(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: items.isNotEmpty,
              child: Text(
                header,
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //Button to remove all expired items
            Visibility(
              visible: isExpired && items.isNotEmpty,
              child: TextButton(
                onPressed: () async {
                  await removeExpired();
                  deleteAmount = expired.length;
                  expired = []; today = []; tomorrow = []; fiveDays = []; sevenDays = [];
                  print("THis is the expired list ${expired}");
                  counter = 0;
                },
                child: Text(
                  "Remove All",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      sliver: SliverList(
        //The content associated with a StickyHeader
        delegate: SliverChildListDelegate([
          Visibility(
            visible: items.isNotEmpty,
            child: Column(
              children: items,
            )
          ),
        ])
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Listens for changes from the users database of items
    //(items added / removed etc)

    List<Widget> addToList(int expiry, var item, list) {
      //Checks if the expiry date is in the range
      final itemName = item.get('ProductName').toString();
      //Check if user is searching or not
      if(this.widget.search != null) {
        //Checks if the product name contains the search term
        if(itemName.toLowerCase().contains(this.widget.search.toLowerCase()) || this.widget.search == "") {
          //Converts the quantity to an integer
          var itemQuantity = int.parse(item.get('Quantity').toString());
          //Creates the expiry item widget and adds it to the list of widgets
          final itemWidget = ExpiryItem(product: itemName,quantity: itemQuantity,expiryDate: expiry,
            callback: (remove) {
              updateItemAmount(item.id, remove, itemQuantity, -1);
              expired = []; today = []; tomorrow = []; fiveDays = []; sevenDays = [];
              counter = 0;
            }
          );
          list.add(itemWidget);
        }
      }else {
        var itemQuantity = int.parse(item.get('Quantity').toString());
        final itemWidget = ExpiryItem(product: itemName,quantity: itemQuantity,expiryDate: expiry,
          callback: (remove) {
            updateItemAmount(item.id, remove, itemQuantity, -1);
            expired = []; today = []; tomorrow = []; fiveDays = []; sevenDays = [];
            counter = 0;
          }
        );
        list.add(itemWidget);
      }
      return list;
    }

    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection(userCol).snapshots(),
      builder: (context, snapshot) {
        //WHen data is gotten creates a list of expiry item widgets
        //Checks if data returned
        if(widget.search != prevSearch) {
          expired = []; today = []; tomorrow = []; fiveDays = []; sevenDays = [];
          counter = 0;
        }
        if(snapshot.hasData && counter == 0) {
          counter++;
          //Gets a list of the documents
          final items = snapshot.data.docs;

          DateTime now = DateTime.now();
          //Loops through the documents
          for(var item in items) {
            //Gets the document data
            //Gets the fields (ExpiryDate, ProductName, Category and quantity)
            final itemExpiry = item.get('ExpiryDate');
            DateTime expiry = DateTime.parse(itemExpiry);
            //Calculates the days till expiry
            int daysTillExpiry = expiry.difference(DateTime(now.year, now.month, now.day)).inDays;

            if(daysTillExpiry <= -1 && daysTillExpiry >= -1000000) {
              if(deleteAmount == 0) {
                expired = addToList(daysTillExpiry, item, expired);
              }else {
                deleteAmount--;
              }
            }else if(daysTillExpiry == 0) {
              today = addToList(daysTillExpiry, item, today);
            }else if(daysTillExpiry == 1) {
              tomorrow = addToList(daysTillExpiry, item, tomorrow);
            }else if(daysTillExpiry <= 5 && daysTillExpiry >= 2) {
              fiveDays = addToList(daysTillExpiry, item, fiveDays);
            }else if(daysTillExpiry <= 7 && daysTillExpiry >= 6) {
              sevenDays = addToList(daysTillExpiry, item, sevenDays);
            }
          }
          if(expired.isEmpty && today.isEmpty && tomorrow.isEmpty && fiveDays.isEmpty && sevenDays.isEmpty) {
            noItems = true;
            if(this.widget.search != null) {
              results = false;
            }
          }
          //Notification for if food is going off
          // if(expired.length > 0){
          //   total = expired.length;
          //   day = "Expired";
          //   showNotification(total,day);
          // }
          // else if(tomorrow.length > 0){
          //   total = tomorrow.length;
          //   day = "Tomorrow";
          //   showNotification(total,day);
          // }
          // else if(fiveDays.length > 0){
          //   total = tomorrow.length;
          //   day = "5 Days";
          //   showNotification(total,day);
          // }
          // else if(sevenDays.length > 0){
          //   total = tomorrow.length;
          //   day = "7 Days";
          //   showNotification(total,day);
          // }
          prevSearch = this.widget.search;
        }

        if(noItems) {
          return Column(
            children: [
              Text(
                !results ? "No results found" : "No items going off in the next 7 days!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize:20.0,
                ),
              ),
              Image(image: AssetImage("assets/icon.png"))
            ],
          );
        }else {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              //This is required for the SliverStickyHeader
              CustomScrollView(
                //The StickyHeaders
                slivers: <Widget>[
                  createSliverHeader(expired, "Expired", true),
                  createSliverHeader(today, "Today", false),
                  createSliverHeader(tomorrow, "Tomorrow", false),
                  createSliverHeader(fiveDays, "Five Days", false),
                  createSliverHeader(sevenDays, "Seven Days", false),
                ]
              ),
              //Positions the Quantity text to the right
              //of the page so that it is constantly visible
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  "Quantity",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ]
          );
        }
      }
    );
  }

  // void showNotification(int total, String day) {
  //   flutterLocalNotificationsPlugin.show(
  //       0,
  //       "$day!",
  //       "Items Expiring: $total",
  //       NotificationDetails(
  //           android: AndroidNotificationDetails(channel.id, channel.name, channel.description,
  //               importance: Importance.high,
  //               color: Colors.blue,
  //               playSound: true,
  //               icon: '@assets/icon.png')));
  // }

}
