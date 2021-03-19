import "package:best_before_app/components/ExpiryItem.dart";

bool hasNotified = false;

List<ExpiryItemData> expiryItems = [
  ExpiryItemData(expiryDate: DateTime.now().subtract(const Duration(days: 3)), daysTillExpiry: -3, product: "Carrots", quantity: 10, category: "Vegetables"),
  ExpiryItemData(expiryDate: DateTime.now(), daysTillExpiry: 0, product: "Cheese", quantity: 13, category: "Dairy"),
  ExpiryItemData(expiryDate: DateTime.now().add(const Duration(days: 1)), daysTillExpiry: 1, product: "Cake", quantity: 10, category: "Dairy"),
  ExpiryItemData(expiryDate: DateTime.now().add(const Duration(days: 1)), daysTillExpiry: 1, product: "Rice", quantity: 13, category: "Dairy"),
  ExpiryItemData(expiryDate: DateTime.now().add(const Duration(days: 4)), daysTillExpiry: 4, product: "Corn", quantity: 15, category: "Meat"),
  ExpiryItemData(expiryDate: DateTime.now().add(const Duration(days: 4)), daysTillExpiry: 4,product: "McNuggets", quantity: 1500, category: "Vegetables"),
  ExpiryItemData(expiryDate: DateTime.now().add(const Duration(days: 7)), daysTillExpiry: 7, product: "Venison", quantity: 5, category: "Vegetables"),
  ExpiryItemData(expiryDate: DateTime.now().add(const Duration(days: 7)), daysTillExpiry: 7, product: "Pork", quantity: 7, category: "Meat"),
  //
  ExpiryItemData(expiryDate: DateTime.now().subtract(const Duration(days: 2)), daysTillExpiry: -2, product: "Peas", quantity: 10, category: "Meat"),
  ExpiryItemData(expiryDate: DateTime.now().subtract(const Duration(days: 3)), daysTillExpiry: -3, product: "Cheese", quantity: 13, category: "Meat"),
  ExpiryItemData(expiryDate: DateTime.now(), daysTillExpiry: 0, product: "Cake", quantity: 10, category: "Dairy"),
  ExpiryItemData(expiryDate: DateTime.now().add(const Duration(days: 1)), daysTillExpiry: 1, product: "Rice", quantity: 13, category: "Dairy"),
  ExpiryItemData(expiryDate: DateTime.now().add(const Duration(days: 4)), daysTillExpiry: 4, product: "Corn", quantity: 15, category: "Dairy"),
  ExpiryItemData(expiryDate: DateTime.now().add(const Duration(days: 4)), daysTillExpiry: 4, product: "McNuggets", quantity: 1500, category: "Dairy"),
  ExpiryItemData(expiryDate: DateTime.now().add(const Duration(days: 7)), daysTillExpiry: 7, product: "Venison", quantity: 5, category: "Vegetables"),
  ExpiryItemData(expiryDate: DateTime.now().add(const Duration(days: 7)), daysTillExpiry: 7, product: "Pork", quantity: 7, category: "Vegetables"),
  //
  ExpiryItemData(expiryDate: DateTime.now().subtract(const Duration(days: 1)), daysTillExpiry: -1, product: "Celery", quantity: 10, category: "Vegetables"),
  ExpiryItemData(expiryDate: DateTime.now(), daysTillExpiry: 0, product: "Cheese", quantity: 13, category: "Vegetables"),
  ExpiryItemData(expiryDate: DateTime.now().add(const Duration(days: 1)), daysTillExpiry: 1, product: "Cake", quantity: 10, category: "Vegetables"),
  ExpiryItemData(expiryDate: DateTime.now().add(const Duration(days: 1)), daysTillExpiry: 1, product: "Rice", quantity: 13, category: "Vegetables"),
  ExpiryItemData(expiryDate: DateTime.now().add(const Duration(days: 4)), daysTillExpiry: 4, product: "Corn", quantity: 15, category: "Vegetables"),
  ExpiryItemData(expiryDate: DateTime.now().add(const Duration(days: 4)), daysTillExpiry: 4, product: "McNuggets", quantity: 1500, category: "Vegetables"),
  ExpiryItemData(expiryDate: DateTime.now().add(const Duration(days: 7)), daysTillExpiry: 7, product: "Venison", quantity: 5, category: "Meat"),
  ExpiryItemData(expiryDate: DateTime.now().add(const Duration(days: 7)), daysTillExpiry: 7, product: "Pork", quantity: 7, category: "Meat"),
];

List<List> getItems(String itemName) {
  List<ExpiryItemData> goneoff = [];
  List<ExpiryItemData> today = [];
  List<ExpiryItemData> tomorrow = [];
  List<ExpiryItemData> days5 = [];
  List<ExpiryItemData> days7 = [];

  //Checks the date for a specific  list item and decides what expiry list to add it to
  for(ExpiryItemData item in expiryItems) {
    if(itemName == null || item.product.toLowerCase().contains(itemName)) {
      if(item.daysTillExpiry < 0) {
        goneoff.add(item);
      }else if(item.daysTillExpiry == 0) {
        today.add(item);
      }else if(item.daysTillExpiry == 1) {
        tomorrow.add(item);
      }else if(item.daysTillExpiry <= 5) {
        days5.add(item);
      }else if(item.daysTillExpiry <= 7) {
        days7.add(item);
      }/*else if(item.daysTillExpiry > 5) {
        days7.add(item);
      }*/
    }
  }
  hasNotified = true;
  //Returns the lists of data so that it can be rendered
  return [goneoff, today, tomorrow, days5, days7];
}

void removeExpired() {
  expiryItems.removeWhere((item) => item.daysTillExpiry < 0);
}

void removeItem(ExpiryItemData toRemove) {
  expiryItems.removeWhere((item) => item == toRemove);
}