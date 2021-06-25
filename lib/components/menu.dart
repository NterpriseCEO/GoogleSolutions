import "package:best_before_app/pages/CameraPage.dart";
import '../pages/components/DashboardCategories.dart';
import 'package:best_before_app/pages/ExpirationPage.dart';
import "package:best_before_app/pages/InventoryOverview.dart";
import 'package:best_before_app/pages/Logout.dart';
import 'package:flutter/material.dart';
import 'package:best_before_app/pages/Dashboard.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int currentPage = 1;
  //Lets you manipulate which page is visible in page view
  PageController pageController;
  PageController pageController2;

  @override
  void initState() {
    super.initState();
    //Initialises the pageController
    pageController = PageController(initialPage: 1);
    pageController2 = PageController(initialPage: 1);
  }

  @override
  Widget build(BuildContext context) {
    //This widget is used to process whether should
    //the current page or not
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
      },
      child: WillPopScope(
        //Does nothing?
        onWillPop: () {
          return;
        },
        //Scaffold provides APIs for showing
        //drawers, snack bars, etc
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          //Inserts padding to avoid the status bar on Android / IOS
          body: SafeArea(
            //Scrollable list of pages
            child: PageView(
              scrollDirection: Axis.vertical,
              controller: pageController2,
              children: [
                Settings(),
                PageView(
                  //the pageController
                  controller: pageController,
                  //The pages in the PageView
                  children: <Widget>[
                    //The page pages
                    Container(
                      color: Colors.white,
                      child: ExpirationPage(),
                      // child: ExpirationPage(),
                    ),
                    Container(
                      //The ScanPicture() page
                      child: ScanPicture(),
                    ),
                    InventoryOverview(
                      // goToPage: (int page) {
                      //   setState(() {
                      //     currentPage = page;
                      //   });
                      //   pageController.animateToPage(
                      //     page,
                      //     //The animation speed
                      //     duration: Duration(
                      //       milliseconds: 500,
                      //     ),
                      //     //The animation tweening effect
                      //     curve: Curves.easeInOut,
                      //   );
                      // },
                    ),
                  ],
                  //Check if the page is changed and set the currentPage index
                  onPageChanged: (int index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                )
              ],
            )
          ),
          //The bottom menu
          bottomNavigationBar: BottomNavigationBar(
            //Disable text labels
            backgroundColor: Colors.amber,
            elevation: 0,
            selectedItemColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            //When tapping the labels
            //change the page
            onTap: (int index) {
              //Set states of variables in here
              setState(() {
                currentPage = index;
              });
              //Animates to the page at this specific index
              pageController.animateToPage(
                currentPage,
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
                label: "Expiry List",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt_outlined),
                label: "Camera",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.set_meal_outlined),
                label: "Inventory",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
