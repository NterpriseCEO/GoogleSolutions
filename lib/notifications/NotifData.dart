import "package:best_before_app/UpdateDatabase.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

import 'LocalNotifications.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
Future<void> getData() async {
  // cancelMessages();
  //
  // List<int> days = [0, 0, 0, 0, 0, 0, 0, 0];
  // int goneOffCount = 0;
  // await firestore.collection(userCol).get().then((snapshot) {
  //   //Gets a list of all the documents
  //   List<DocumentSnapshot> allDocs = snapshot.docs;
  //   //Loops through the documents and calculates how many of each item are going off on a certain day
  //   allDocs.forEach((DocumentSnapshot document) {
  //     //Gets and converts the expiry date into daysTillExpiry, a countdown
  //     DateTime date = DateTime.parse(document.get("ExpiryDate"));
  //     DateTime now = DateTime.now();
  //     int daysTillExpiry = date.difference(DateTime(now.year, now.month, now.day)).inDays;
  //     int quantity = int.parse(document.get("Quantity").toString());
  //
  //     if(daysTillExpiry >= 0 && daysTillExpiry <= 7) {
  //       days[daysTillExpiry]++;
  //     }else if(daysTillExpiry < 0) {
  //       goneOffCount++;
  //     }
  //     print("The quantity is: $quantity");
  //   });
  //
  //   /*Loops through the next seven days
  //     and creates notifications if items have gone off
  //     or are going off in the next seven days.
  //    */
  //   for(int i = 0; i < days.length; i++) {
  //     if(i > 0) {
  //       if(days[i] > 0) {
  //         print(days[i]);
  //         notification("${days[i]} item(s) going off tomorrow", "Items Expiring!", i-1);
  //         notification("${days[i]} item(s) going off today", "Items Expiring!", i);
  //       }
  //     }
  //   }
  //   if(goneOffCount > 0) {
  //     notification("$goneOffCount items already gone off", "Items Expired!", 1);
  //   }
  // });
}