import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { CieloConstructor, Cielo, EnumBrands } from "cielo";

admin.initializeApp();

const merchantId = functions.config().cielo.merchantId;
const merchantKey = functions.config().cielo.merchantKey;

const cieloParams: CieloConstructor = {
  merchantId: merchantId,
  merchantKey: merchantKey,
  sandbox: true,
  debug: true,
};

const cielo = new Cielo(cieloParams);

export const authorizeCreditCard = functions.https.onCall(async (data, context) => {
  if (data === null) {
    return {
      "success": false,
      "error": {
        "code": -1,
        "message": "Dados não informados",
      },
    };
  }

  if (!context.auth) {
    return {
      "success": false,
      "error": {
        "code": -1,
        "message": "Nenhum usuário logado",
      },
    };
  }

  const userId = context.auth.uid;

  const snapshot = await admin.firestore().collection("users").doc(userId).get();
  const userData = snapshot.data();

  console.log("Iniciando Autorização");

  let brand: EnumBrands;
  switch(data.creditCard.brand) {
    case "VISA":
      brand = EnumBrands.VISA;
      break;    
    case "MASTER":
      brand = EnumBrands.MASTER;
      break;    
    case "AMEX":
      brand = EnumBrands.AMEX;
      break;    
    case "ELO":
      brand = EnumBrands.ELO;
      break;    
    case "JCB":
      brand = EnumBrands.JCB;
      break;    
    case "DINERS":
      brand = EnumBrands.DINERS;
      break;    
    case "DISCOVERY":
      brand = EnumBrands.DISCOVERY;
      break;
    case "HIPERCARD":
      brand = EnumBrands.HIPERCARD;
      break;
    default:
      return {
        "success": false,
        "error": {
          "code": -1,
          "message": "Cartão não suportado " + data.creditCard.brand
        },
      }
  }
});

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", { structuredData: true });
  response.send("Hello from Firebase!");
});
