import "package:best_before_app/components/ExpiryItem.dart";
import "package:best_before_app/notifications/LocalNotifications.dart";

bool hasNotified = false;

List<ExpiryItemData> expiryItems = [
  ExpiryItemData(expiryDate: -3, product: "Carrots", quantity: 10),
  ExpiryItemData(expiryDate: 0, product: "Cheese", quantity: 13),
  ExpiryItemData(expiryDate: 1, product: "Cake", quantity: 10),
  ExpiryItemData(expiryDate: 1, product: "Rice", quantity: 13),
  ExpiryItemData(expiryDate: 4, product: "Corn", quantity: 15),
  ExpiryItemData(expiryDate: 4, product: "McNuggets", quantity: 1500),
  ExpiryItemData(expiryDate: 7, product: "Venison", quantity: 5),
  ExpiryItemData(expiryDate: 7, product: "Pork", quantity: 7),
  //
  ExpiryItemData(expiryDate: -2, product: "Peas", quantity: 10),
  ExpiryItemData(expiryDate: 0, product: "Cheese", quantity: 13),
  ExpiryItemData(expiryDate: 1, product: "Cake", quantity: 10),
  ExpiryItemData(expiryDate: 1, product: "Rice", quantity: 13),
  ExpiryItemData(expiryDate: 4, product: "Corn", quantity: 15),
  ExpiryItemData(expiryDate: 4, product: "McNuggets", quantity: 1500),
  ExpiryItemData(expiryDate: 7, product: "Venison", quantity: 5),
  ExpiryItemData(expiryDate: 7, product: "Pork", quantity: 7),
  //
  ExpiryItemData(expiryDate: -1, product: "Celery", quantity: 10),
  ExpiryItemData(expiryDate: 0, product: "Cheese", quantity: 13),
  ExpiryItemData(expiryDate: 1, product: "Cake", quantity: 10),
  ExpiryItemData(expiryDate: 1, product: "Rice", quantity: 13),
  ExpiryItemData(expiryDate: 4, product: "Corn", quantity: 15),
  ExpiryItemData(expiryDate: 4, product: "McNuggets", quantity: 1500),
  ExpiryItemData(expiryDate: 7, product: "Venison", quantity: 5),
  ExpiryItemData(expiryDate: 7, product: "Pork", quantity: 7),
];

List<List> getItems(String itemName) {
  List<ExpiryItemData> goneoff = [];
  List<ExpiryItemData> today = [];
  List<ExpiryItemData> tomorrow = [];
  List<ExpiryItemData> days5 = [];
  List<ExpiryItemData> days7 = [];

  //Checks the date for a specific  list item and decides what expiry list to add it to
  for(ExpiryItemData item in expiryItems) {
    if(!hasNotified) {
      notification(item.product, item.quantity, item.expiryDate);
    }
    if(itemName == null || item.product.toLowerCase().contains(itemName)) {
      if(item.expiryDate < 0) {
        goneoff.add(item);
      }else if(item.expiryDate == 0) {
        today.add(item);
      }else if(item.expiryDate == 1) {
        tomorrow.add(item);
      }else if(item.expiryDate <= 5) {
        days5.add(item);
      }else if(item.expiryDate <= 7) {
        days7.add(item);
      }
    }
  }
  hasNotified = true;
  //Returns the lists of data so that it can be rendered
  return [goneoff, today, tomorrow, days5, days7];
}

void removeExpired() {
  expiryItems.removeWhere((item) => item.expiryDate < 0);
}

void removeItem(ExpiryItemData toRemove) {
  expiryItems.removeWhere((item) => item == toRemove);
}