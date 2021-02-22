import 'package:flutter/material.dart';

class InventoryCard extends StatelessWidget {
  final String category;
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