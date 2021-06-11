import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

enum LegendShape { Circle, Rectangle }

class Dashboard extends StatefulWidget {

  @override
  _DashboardState createState() => _DashboardState();

}

class _DashboardState extends State<Dashboard> {

  Map<String, double> dataMap = {
    "Consumed": 76,
    "Wasted": 24,
  };

  List<Color> colorList = [
    Colors.blue,
    Colors.red,
  ];

  int key = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(100.0, 50.0, 8.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  "Dashboard",
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(50, 20, 120, 20),
                      child: Text(
                        "Food Score",
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment : MainAxisAlignment.spaceAround,
                        children: [
                            Container(
                              child: PieChart(
                              dataMap: dataMap,
                              animationDuration: Duration(milliseconds: 800),
                              chartLegendSpacing: 32,
                              chartRadius: MediaQuery.of(context).size.width / 3.2,
                              colorList: colorList,
                              initialAngleInDegree: 0,
                              chartType: ChartType.ring,
                              ringStrokeWidth: 32,
                              centerText: "Score",
                              legendOptions: LegendOptions(
                                showLegendsInRow: false,
                                legendPosition: LegendPosition.right,
                                showLegends: false,
                                legendShape: BoxShape.circle,
                                legendTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              chartValuesOptions: ChartValuesOptions(
                                showChartValueBackground: false,
                                showChartValues: false,
                                showChartValuesInPercentage: false,
                                showChartValuesOutside: false,
                                decimalPlaces: 1,
                              ),
                          ),
                            ),
                          Container(
                            height: 100,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: AssetImage("assets/UpArrow.png")
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                  "20% less",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal,
                                  )
                              ),
                              Text(
                                "Wastage",
                                  style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Divider(
                                  color: Colors.black,
                              )

                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ),
              Container(
                margin: EdgeInsets.all(30),
                child: Column(
                  children: [
                    Text(
                      "Your Food Trends",
                      style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(child:
                      Row(
                        children: [
                          Text(""
                              )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
          ),
        );
  }


}