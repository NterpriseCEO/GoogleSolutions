import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
admin.initializeApp();
const db = admin.firestore();
const fcm = admin.messaging();

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript
// JSON.stringify(doc.data().ExpiryDate)
export const expiryDateChecker = functions.pubsub.schedule("0 06 * * *")
    .timeZone("Europe/London").onRun(async (variable) => {
      const collections = await db.listCollections();

      const options = {
        priority: "high",
        timeToLive: 60 * 60 * 24,
      };

      await collections.forEach(async (collection) => {
        const snapshot = await collection.get();
        let amountToday = 0;
        let amountTomorrow = 0;
        let amountExpired = 0;
        await snapshot.forEach((doc) => {
          const Date1 = new Date();
          Date1.setHours(0, 0, 0, 0);
          const Date2 = new Date(doc.data().ExpiryDate);
          const diffInTime = Date2.getTime() - Date1.getTime();
          const diffInDays = Math.floor(diffInTime / (1000 * 3600 * 24));

          if (diffInDays == 0) {
            amountToday++;
          } else if (diffInDays == 1) {
            amountTomorrow++;
          } else if (diffInDays < 0) {
            amountExpired++;
            try {
              db.collection("expiryGroups").doc("Users")
                  .collection(collection.id).doc(doc.id)
                  .update({Expired: "true"});
            } catch (e: unknown) {
              console.log(e);
            }
          }
        });
        if (amountToday > 0) {
          const message = {
            notification: {
              title: "Items Expiring!",
              body: `${amountToday} Item(s) Expiring Today!`,
              sound: "default",
              badge: "1",
            },
          };
          fcm.sendToTopic(collection.id, message, options);
        }

        if (amountTomorrow > 0) {
          const message = {
            notification: {
              title: "Items Expiring!",
              body: `${amountTomorrow} Item(s) Expiring Tommorow!`,
              sound: "default",
              badge: "1",
            },
          };
          fcm.sendToTopic(collection.id, message, options);
        }
        if (amountExpired > 0) {
          const message = {
            notification: {
              title: "Items Expiring!",
              body: `${amountExpired} Item(s) Already Expired!`,
              sound: "default",
              badge: "1",
            },
          };
          fcm.sendToTopic(collection.id, message, options);
        }
      });
    });
