import 'package:flutter/material.dart';

typedef Callback(int pageNumber);

class InventoryCard extends StatelessWidget {
  final String category;
  final Callback goToPage;
  InventoryCard({ this.category, @required this.goToPage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //This code navigates to the correct inventory page
        final result = await Navigator.pushNamed(context, "/inventory", arguments: {
          "category": category
        });
        print(result);
        //This checks if trying to add a new item to the inventory
        if(result == 1) {
          goToPage(result);
        }
      },
      //The Card that links to an inventory page
      child: Card(
        //Make it flat
        elevation: 0,
        //Give it a border with border radius
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          //Border colour and width
          side: BorderSide(
            color: Colors.orange,
            width:2.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              //Icon for the card
              Expanded(
                flex: 4,
                child: FadeInImage(image: AssetImage("assets/$category.png"), placeholder: AssetImage("assets/barcode.png")),
              ),
              //Card Title
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