import 'package:flutter/material.dart';

class InventoryCard extends StatefulWidget {
  final String category;
  final bool isBreakdownCard;
  int expiredAmount;

  InventoryCard({ this.category, this.isBreakdownCard, this.expiredAmount });

  @override
  _InventoryCardState createState() => _InventoryCardState();
}

class _InventoryCardState extends State<InventoryCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if(this.widget.isBreakdownCard) {

        }else {
          Navigator.pushNamed(context, "/inventory", arguments: {
            "category": widget.category
          });
        }
      },
      //The Card that links to an inventory page
      child: Card(
        //Make it flat
        elevation: 0,
        clipBehavior: Clip.hardEdge,
        //Give it a border with border radius
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          //Border colour and width
          side: BorderSide(
            color: widget.category != "NA" ? Colors.orange : Colors.white,
            width:2.0,
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            this.widget.isBreakdownCard ? FractionallySizedBox(
              widthFactor: 1,
              heightFactor: widget.expiredAmount/100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(7.5),
                ),
              ),
            ) : Container(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  //Icon for the card
                  Expanded(
                    flex: 4,
                    child: widget.category != "NA" ?
                      FadeInImage(
                        image: AssetImage("assets/${widget.category.split(" ").join()}.png"),
                        placeholder: AssetImage("assets/barcode.png")
                      ) : Container(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      widget.isBreakdownCard ? widget.category != "NA" ? "${widget.expiredAmount}%" : "" : widget.category,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize:20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}