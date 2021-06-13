import * as functions from "firebase-functions";
import * as logging from "@google-cloud/logging";

// Creates a client
const logs = new logging.Logging();

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const helloWorld = functions.https.onRequest((request, response) => {
  logs.log("test-log--name").entry("go fuck youself google cloud");
  response.send("Hello from Firebase!");
});
