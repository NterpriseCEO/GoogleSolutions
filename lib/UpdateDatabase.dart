import 'dart:math';

import 'package:best_before_app/notifications/NotifData.dart';
import 'package:best_before_app/pages/components/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

String userCol = "";

//Changes the item quantity
void updateItemAmount(String id, bool remove, int quantity, int increment) async {
  //References the users database collection
  DocumentReference document = firestore.collection(userCol).doc(id);
  //Removes the item if the quantity is <= 1
  //Or if boolean = true
  if(remove) {
    document.delete();
  }else {
    //Checks if document exists and then increments the Quantity value
    document.get().then((doc) => {
      if(doc.exists) {
        document.update({"Quantity": FieldValue.increment(increment)})
        .catchError((error) {
          print(error);
        })
      }
    });
    if(increment == -1 && quantity == 1) {
      document.delete();
    }
  }
  Future.delayed(const Duration(seconds: 1), () {
    getData();
  });
}

//Adds an item to the databse
void addItemToDB(String itemName, String category, int amount, String expiryDate) {
  firestore.collection(userCol).add({
    'Category':  category,
    'ProductName': itemName,
    'Quantity': amount,
    "ExpiryDate": expiryDate
  }).then((docRef) {
    firestore.collection("expiryGroups/Users/$userCol/").doc(docRef.id).set({
      'Category': category,
      'ProductName': itemName,
      'Quantity': amount,
      "Expired": false,
      "week": weekNumber(DateTime.parse(expiryDate))
    });
  });
  Future.delayed(const Duration(seconds: 1), () {
    getData();
  });
}

//Removes all expired items
void removeExpired() async {
  //References the users database collection
  await firestore.collection(userCol).get().then((snapshot) {
    //Gets a list of all the documents
    List<DocumentSnapshot> allDocs = snapshot.docs;
    //Loops through the documents and deletes them if the expiry date is before today's date
    allDocs.forEach((DocumentSnapshot document) {
      DateTime date = DateTime.parse(document.get("ExpiryDate"));
      if(date.isBefore(DateTime.now())) {
        document.reference.delete();
      }
    });
  });
  Future.delayed(const Duration(seconds: 1), () {
    getData();
  });
}

void deleteOldData() {
  WriteBatch batch = FirebaseFirestore.instance.batch();
  firestore.collection("expiryGroups/Users/$userCol/")
  .where("week", isLessThanOrEqualTo: weekNumber(DateTime.now())-3).get().then((querySnapshot) {
    querySnapshot.docs.forEach((document) {
      batch.delete(document.reference);
    });
    return batch.commit();
  });
}

Future<List<int>> CalculateData(String Cat) async {
  int foodCountTotal = 0;
  int expiredCount = 0;
  int percentExpired = 0;
  await firestore.collection("expiryGroups/Users/$userCol/")
    .where("week", isEqualTo: weekNumber(DateTime.now())-1).get().then((snapshot) {
    List<DocumentSnapshot> Docs = snapshot.docs;
    Docs.forEach((DocumentSnapshot document) {
      if(Cat == document.get("Category")){
        foodCountTotal = foodCountTotal + 1;
        if(document.get("Expired") == true){
          expiredCount = expiredCount + 1;
        }
      }
    });
  });
  try {
    percentExpired = percentExpired + ((expiredCount/foodCountTotal)*100).round();
  } catch (e) {
    print(e);
  }
  return [percentExpired, foodCountTotal, expiredCount];
}

Future<int> CalculatePercent() async {
  //boolean false means we wasted, true means we wasted less
  int lessWaste = 0;

  int foodCountTotal = 0;
  int expiredCount = 0;
  int percentExpired = 0;
  int foodCountTotal2 = 0;
  int expiredCount2 = 0;
  int percentExpired2 = 0;
  int expiryChange = 0;

  //calculate last weeks data
  await firestore.collection("expiryGroups/Users/$userCol/")
      .where("week", isEqualTo: weekNumber(DateTime.now()) - 1)
      .get()
      .then((snapshot) {
    List<DocumentSnapshot> Docs = snapshot.docs;
    Docs.forEach((DocumentSnapshot document) {
      foodCountTotal = foodCountTotal + 1;
      if (document.get("Expired") == true) {
        expiredCount = expiredCount + 1;
      }
    });
    try {
      percentExpired =
          percentExpired + ((expiredCount / foodCountTotal) * 100).round();
    } catch (e) {
      print(e);
    }
  });

  //calculate 2 weeks ago data
  await firestore.collection("expiryGroups/Users/$userCol/")
      .where("week", isEqualTo: weekNumber(DateTime.now()) - 2)
      .get()
      .then((snapshot) {
    List<DocumentSnapshot> Docs = snapshot.docs;
    Docs.forEach((DocumentSnapshot document) {
      foodCountTotal2 = foodCountTotal2 + 1;
      if (document.get("Expired") == true) {
        expiredCount2 = expiredCount2 + 1;
      }
    });
    try {
      percentExpired2 = ((expiredCount2 / foodCountTotal2) * 100).round();
    } catch (e) {
      print(e);
    }
  });

  //subtract last week from week before
  //if the value is positive we wasted more, if it goes negative we watsed less so assign bool true
  expiryChange = (percentExpired-percentExpired2);
  // if(expiryChange < 0){
  //   expiryChange = expiryChange * -1;
  //   lessWaste = 1;
  // }
  //return the change in % and if we wasted more or less in a bool in the return statement
  return expiryChange;
}

