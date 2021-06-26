import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../UpdateDatabase.dart';

enum LegendShape { Circle, Rectangle }

int percent = 0;

class ExpiryChart extends StatefulWidget {

  final double expiredAmount;
  final double total;

  ExpiryChart({ this.expiredAmount, this.total });

  @override
  _ExpiryChartState createState() => _ExpiryChartState();
}

class _ExpiryChartState extends State<ExpiryChart> {
  Map<String, double> dataMap = {
    "Consumed": 0,
    "Wasted": 0,
  };

  List<Color> colorList = [
    Colors.blue,
    Colors.red,
  ];

  void get() async {
    percent = await CalculatePercent();
  }

  @override
  void initState() {
    super.initState();
    dataMap["Consumed"] = widget.total - widget.expiredAmount;
    dataMap["Wasted"] = widget.expiredAmount;
  }

  @override
  Widget build(BuildContext context) {

    int key = 0;

    return Column(
      children: <Widget>[
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Container(
              //   margin: EdgeInsets.fromLTRB(50, 20, 120, 20),
              //   child: Text(
              //     "Food Score",
              //     style: TextStyle(
              //       fontSize: 22.0,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              Row(
                mainAxisAlignment : MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: PieChart(
                      dataMap: dataMap,
                      animationDuration: Duration(seconds: 20),
                      chartLegendSpacing: 32,
                      chartRadius: MediaQuery.of(context).size.width / 2,
                      colorList: colorList,
                      initialAngleInDegree: 90,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 32,
                      centerText: "Score",
                      legendOptions: LegendOptions(
                        showLegendsInRow: true,
                        legendPosition: LegendPosition.bottom,
                        showLegends: true,
                        legendShape: BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: true,
                        showChartValuesOutside: true,
                        decimalPlaces: 1,
                      ),
                    ),
                  ),
                  SizedBox(width:20.0,),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: FutureBuilder<int>(
                      future: CalculatePercent(),
                      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                        if(snapshot.hasData) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image(
                                width: MediaQuery.of(context).size.width / 8,
                                image: AssetImage(snapshot.data < 0 ? "assets/DownArrow.png" : "assets/UpArrow.png"),
                              ),
                              Text(
                                snapshot.data < 0 ? "Food wastage is \ndown ${snapshot.data*-1}%" : "Food wastage is \nup ${snapshot.data}%",
                                textAlign: TextAlign.center,
                              )
                            ],
                          );
                        }else {
                          return Text("Loading...");
                        }
                      }
                    ),
                  ),
                ],
              )
            ],
          )
        ),
        // Container(
        //   margin: EdgeInsets.all(30),
        //   child: Column(
        //     children: [
        //       Text(
        //         "Your Food Trends",
        //         style: TextStyle(
        //           fontSize: 22.0,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //       Expanded(child:
        //         Row(
        //           children: [
        //             Text("")
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // )
      ],
    );
  }
}
