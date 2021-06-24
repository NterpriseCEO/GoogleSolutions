import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

enum LegendShape { Circle, Rectangle }

class ExpiryChart extends StatefulWidget {

  @override
  _ExpiryChartState createState() => _ExpiryChartState();
}

class _ExpiryChartState extends State<ExpiryChart> {
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

    print(dataMap);
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
                      animationDuration: Duration(milliseconds: 800),
                      chartLegendSpacing: 32,
                      chartRadius: MediaQuery.of(context).size.width / 2,
                      colorList: colorList,
                      initialAngleInDegree: 0,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image(
                          width: MediaQuery.of(context).size.width/8,
                          image: AssetImage("assets/UpArrow.png"),
                        ),
                        Text("Food wastage is up 20%")
                      ],
                    ),
                  ),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //
                  //     Text(
                  //       "20% less",
                  //       style: TextStyle(
                  //         fontSize: 12.0,
                  //         fontWeight: FontWeight.normal,
                  //       )
                  //     ),
                  //     Text(
                  //       "Wastage",
                  //       style: TextStyle(
                  //         fontSize: 17.0,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //     Divider(
                  //       color: Colors.black,
                  //     )
                  //   ],
                  // ),
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
