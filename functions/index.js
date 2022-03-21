const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions

exports.helloWorld = functions.https.onCall((request, response) => {
  functions.logger.info({"request": request}, {structuredData: true});
  return {data: "Hello from loja virtual"};
});
