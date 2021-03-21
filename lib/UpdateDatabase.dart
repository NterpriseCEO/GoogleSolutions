import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

String userCol = "";

void updateItemAmount(String id, bool remove, int quantity, int increment) {
  DocumentReference document = firestore.collection(userCol).doc(id);
  print(document);
  if(remove || quantity <= 1) {
    document.delete();
  }else {
    print("Hello");
    document.get().then((doc) => {
      if(doc.exists) {
        document.update({"Quantity": FieldValue.increment(increment)})
        .catchError((error) {
          print(error);
        })
      }
    });
  }
}

void addItemToDB(String itemName, String category, int amount, String expiryDate) {
  print("hello!!!! $userCol");
  firestore.collection(userCol).add({
    'Category':  category,
    'ProductName': itemName,
    'Quantity': amount,
    "ExpiryDate": expiryDate
  });
}

void removeExpired() {
  //firestore.instance.collection(userCol).getDocuments().
}