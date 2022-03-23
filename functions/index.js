const functions = require("firebase-functions");
const admin = require("firebase-admin");
import { CieloConstructor, Cielo } from 'cielo';

admin.initializeApp();

const merchantId = functions.config().cielo.merchantId;
const merchantKey = functions.config().cielo.merchantKey;


const cieloParams = {
    merchantId: merchantId,
    merchantKey: merchantKey,
    sandbox: true,
    debug: true
}

const cielo = new Cielo(cieloParams);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions

exports.helloWorld = functions.https.onCall((request, response) => {
  functions.logger.info({ "request": request }, { structuredData: true });
  return { data: "Hello from loja virtual" };
});

exports.getUserData = functions.https.onCall((data, context) => {
  functions.logger.info("Get user data", { structuredData: true });
  if (!context.auth) {
    return { data: "Nenhum usuário logado!" };
  }
  return admin.firestore().collection("users").doc(context.auth.uid).get().then((snapshot) => snapshot.data());
});

exports.onNewOrder = functions.firestore.document("/orders/{orderId}").onCreate((snapshot, context) => {
  const orderId = context.params.orderId;
  console.log(orderId);
});
