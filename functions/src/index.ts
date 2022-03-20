import * as functions from "firebase-functions";
import * as admin from 'firebase-admin';

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const helloWorld = functions.https.onCall((data, context) => {
    console.log(data);
    console.log(context);
    return { data: "Hello from Cloud Functions!!!" };
});

export const getUserData = functions.https.onCall(async (data, context) => {
    console.log(data);
    if (!context.auth) {
        return {
            data: "Nenhum usuário logado"
        };
    }

    const snapshot = await admin.firestore().collection("users").doc(context.auth.uid).get();
    return {
        data: snapshot.data
    };
});