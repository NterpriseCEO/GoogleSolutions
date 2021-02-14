import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: Menu()
));

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int currentPage = 0;
  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return;
      },
      child: Scaffold(
        body: SafeArea(
          child: PageView(
            controller: pageController,
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("page 1"),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("page 2"),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("page 3"),
                ),
              ),
            ],
            onPageChanged: (int index) {
              setState(() {
                currentPage = index;
              });
            }
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (int index) {
            setState(() {
              currentPage = index;
            });
            pageController.animateToPage(
              index,
              duration: Duration(
                milliseconds: 500,
              ),
              curve: Curves.easeIn,
            );
          },
          currentIndex: currentPage,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.access_time),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_outlined),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.set_meal_outlined),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}
