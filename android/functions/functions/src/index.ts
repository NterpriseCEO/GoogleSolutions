import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
admin.initializeApp();
const db = admin.firestore();
const fcm = admin.messaging();

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript
// JSON.stringify(doc.data().ExpiryDate)
export const expiryDateChecker =
functions.https.onRequest(async (request, response) => {
  const collections = await admin.firestore().listCollections();
  collections.forEach(async (collection) => {
    const snapshot = await collection.get();
    let amount = 0;
    let i = 0;
    const Arr: number[] = [];
    await snapshot.forEach((doc) => {
      const Date1 = new Date();
      Date1.setHours(0, 0, 0, 0);
      const Date2 = new Date(doc.data().ExpiryDate);
      const diffInTime = Date2.getTime() - Date1.getTime();
      const diffInDays = Math.floor(diffInTime / (1000 * 3600 * 24));

      Arr[i] = diffInDays;
      if (JSON.stringify(Arr[i]) === "0") {
        amount++;
      }
      i++;
    });
    // if (amount > 0) {
    const delivery = "eQInV7OQT8aZfNHLjYu-rL:APA91bF-JYj4w_jniobh9"+
      "gv4fGR7nvue8tmVDCd1Wal98hJLc9CygNhExue7b7M7"+
      "gfVq4eN8UlCQJrHFpPoqBFxLWttZh0B4We1LtXM"+
      "mFtpmEMzX-s4sGOjyveGly7NE8RFQ4T0NJ1Kg";
    const message = {
      notification: {
        title: "Expiring!",
        body: "${amount} Items Expiring!",
        sound: "default",
        badge: "1",
      },
    };
    const options = {
      priority: "high",
      timeToLive: 60 * 60 * 24,
    };
    fcm.sendToDevice(delivery,
        message, options);
    // }
    response.send(JSON.stringify(collection.id));
  });
});
