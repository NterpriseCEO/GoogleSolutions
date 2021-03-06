import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../UpdateDatabase.dart';

enum LegendShape { Circle, Rectangle }

int percent = 0;

class ExpiryChart extends StatefulWidget {
  final double expiredAmount;
  final double total;

  ExpiryChart({this.expiredAmount, this.total});

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

  @override
  void initState() {
    super.initState();
    print(
        "hello mate ${widget.total} - ${widget.expiredAmount} = ${widget.total - widget.expiredAmount}");
    dataMap["Consumed"] = widget.total - widget.expiredAmount;
    dataMap["Wasted"] = widget.expiredAmount;
  }

  @override
  Widget build(BuildContext context) {
    int key = 0;

    return FutureBuilder<List<int>>(
        future: CalculatePercent(),
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Text(
                  "Dashboard",
                  style: TextStyle(
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height:30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 0.0),
                          child: PieChart(
                            dataMap: dataMap,
                            animationDuration: Duration(seconds: 20),
                            chartLegendSpacing: 32,
                            chartRadius: MediaQuery.of(context).size.width / 2,
                            colorList: colorList,
                            initialAngleInDegree: 90,
                            chartType: ChartType.ring,
                            ringStrokeWidth: 32,
                            centerText: "Score:\n${100 - snapshot.data[1]} / 100",
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
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image(
                            width: MediaQuery.of(context).size.width / 8,
                            image: AssetImage(snapshot.data[0] < 0
                                ? "assets/DownArrow.png"
                                : "assets/UpArrow.png"),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0),
                            child: Text(
                              snapshot.data[0] < 0
                                  ? "${snapshot.data[0] * -1}% Less \nWastage"
                                  : "${snapshot.data[0]}% More \nWastage",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.5,
                              ),
                            ),
                          )
                        ],
                      )
                    ),
                  ]),
              ],
            );
          } else {
            return Text("Loading...");
          }
        });
  }
}
