import 'package:flutter/material.dart';
import "package:best_before_app/pages/CameraPage.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Menu()
  ));
}

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int currentPage = 0;
  //Lets you manipulate which page is visible in page view
  PageController pageController;

  @override
  void initState() {
    super.initState();
    //Initialises the pageController
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    //This widget is used to process whether should
    //the current page or not
    return WillPopScope(
      //Does nothing?
      onWillPop: () {
        return;
      },
      //Scaffold provides APIs for showing
      //drawers, snack bars, etc
      child: Scaffold(
        //Inserts padding to avoid the status bar on Android / IOS
        body: SafeArea(
          //Scrollable list of pages
          child: PageView(
            //the pageController
            controller: pageController,
            //The pages in the PageView
            children: <Widget>[
              //The page pages
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("page 1"),
                ),
              ),
              Container(
                  //The ScanPicture() page
                  child: ScanPicture()
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("page 3"),
                ),
              ),
            ],
            //Check if the page is changed and set the currentPage index
            onPageChanged: (int index) {
              setState(() {
                currentPage = index;
              });
            },
          ),
        ),
        //The bottom menu
        bottomNavigationBar: BottomNavigationBar(
          //Disable text labels
          showSelectedLabels: false,
          showUnselectedLabels: false,
          //When tapping the labels
          //change the page
          onTap: (int index) {
            //Set states of variables in here
            setState(() {
              currentPage = index;
            });
            //Animates to the page at this specific index
            pageController.animateToPage(
              index,
              //The animation speed
              duration: Duration(
                milliseconds: 500,
              ),
              //The animation tweening effect
              curve: Curves.easeInOut,
            );
          },
          //set the current page
          currentIndex: currentPage,
          //The buttons in the navigation bar
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
