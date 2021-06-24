import 'package:best_before_app/pages/components/DashboardCategories.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'components/ExpiryChart.dart';

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
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: MediaQuery.of(context).size.width,
              automaticallyImplyLeading: false,
              leadingWidth: 0,
              stretch: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.symmetric(vertical:10.0),
                centerTitle: true,
                title: Text(
                  "Breakdown",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Hello",
                        style: TextStyle(
                          color: Colors.transparent,
                        ),
                      ),
                      ExpiryChart(),
                    ]
                  ),
                ),
              ),
            ),
            DashboardCategories()
          ],
        )
      ),
    );
  }
}