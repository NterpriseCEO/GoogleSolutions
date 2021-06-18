import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

admin.initializeApp();
// const db = admin.firestore();

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const expiryDateChecker =
functions.https.onRequest(async (request, response) => {
  const collections = await admin.firestore().listCollections();
  collections.forEach(async (collection) => {
    const snapshot = await collection.get();
    snapshot.forEach((doc) => {
      response.send(JSON.stringify(doc.data().ExpiryDate));
    });
  });
});
