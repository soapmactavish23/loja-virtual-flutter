import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { CieloConstructor, Cielo, EnumBrands, TransactionCreditCardRequestModel } from "cielo";
import { user } from "firebase-functions/v1/auth";

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
  const userData = snapshot.data() || {};

  console.log("Iniciando Autorização");

  let brand: EnumBrands;
  switch (data.creditCard.brand) {
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

  const saleDate: TransactionCreditCardRequestModel = {
    merchantOrderId: data.merchantOrderId,
    customer: {
      name: userData.name,
      identity: data.cpf,
      identityType: "CPF",
      email: userData.email,
      deliveryAddress: {
        street: userData.address.street,
        number: userData.address.number,
        complement: userData.address.complement,
        zipCode: userData.address.zipCode.replace(".", "").replace("-", ""),
        city: userData.address.city,
        state: userData.address.state,
        country: "BRA",
        district: userData.address.district,
      },
    },
    payment: {
      currency: "BRL",
      country: "BRL",
      amount: data.amount,
      installments: data.installments,
      softDescriptor: data.softDescriptor,
      type: data.paymentType,
      capture: false,
      creditCard: {
        cardNumber: data.creditCard.cardNumber,
        holder: data.creditCard.holder,
        expirationDate: data.creditCard.expirationDate,
        securityCode: data.creditCard.securityCode,
        brand: brand,
      },
    },
  };

  const transaction = await cielo.creditCard.transaction(saleDate);

});

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", { structuredData: true });
  response.send("Hello from Firebase!");
});
