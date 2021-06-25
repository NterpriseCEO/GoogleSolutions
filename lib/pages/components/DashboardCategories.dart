// /*
// import "package:best_before_app/UpdateDatabase.dart";
// import "package:best_before_app/components/InventoryCard.dart";
// import 'package:flutter/material.dart';
//
// class DashboardCategories extends StatefulWidget {
//
//   DashboardCategories();
//   @override
//   _DashboardCategoriesState createState() => _DashboardCategoriesState();
// }
//
// class _DashboardCategoriesState extends State<DashboardCategories> {
//   List<Widget> inventoryCards = [];
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Future<int> getCards() async {
//     List<String> categories = [
//       "Vegetables",
//       "Fruit",
//       "Dairy",
//       "Beverages",
//       "Sauces",
//       "Bread",
//       "Meat",
//       "Seafood",
//       "Pasta",
//       "Snacks",
//       "Desserts",
//       "Homemade Meals",
//       "Misc"
//     ];
//     DateTime d = DateTime.now();
//     DateTime first = DateTime(d.year, d.month, d.day);
//     int weekDay = d.weekday;
//
//     for(String category in categories) {
//       inventoryCards?.add(InventoryCard(
//           category: category,
//           isBreakdownCard: true,
//           expiredAmount: await CalculateData(category)
//       ));
//     }
//     return 1;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<int>(
//       future: getCards(),
//       builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
//         if (snapshot.hasData) {
//           print(inventoryCards);
//           return SliverGrid.count(
//             crossAxisCount: 2,
//             children: [
//               inventoryCards[0],
//               inventoryCards[1],
//               inventoryCards[2],
//               inventoryCards[3],
//               inventoryCards[4],
//               inventoryCards[5],
//               inventoryCards[6],
//               inventoryCards[7],
//               inventoryCards[8],
//               inventoryCards[9],
//               inventoryCards[10],
//               inventoryCards[11],
//               inventoryCards[12],
//             ],
//           );
//         } else {
//           return SliverGrid.count(
//             crossAxisCount: 2,
//             children: inventoryCards,
//           );
//         }
//       },
//     );
//   }
// }
//
//
// */
