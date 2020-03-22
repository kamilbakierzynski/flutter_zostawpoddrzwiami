import * as functions from 'firebase-functions';
// import { firestore } from 'firebase-admin';
import admin = require('firebase-admin');

admin.initializeApp();

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase!");
});

export const sendNotificationOnRequestPicked = functions.firestore.document("users/{uid}/requests/{requestId}").onUpdate((change, context) => {
    const newValue = change.after.data();
    console.log(newValue);
    if (newValue){
        if (newValue.status == true){
            console.log("status is true");
            const userTokensRef = admin.firestore().collection('users').doc(newValue.customer).collection('tokens');
            userTokensRef.get().then((userTokensSnap) => {
                const userTokens = userTokensSnap.docs.map((snap: any) => snap.id);
                const payload: admin.messaging.MessagingPayload = {
                notification:{
                    title: "Ktoś wypełnia twoją prośbę",
                    body: "Niedługo twoje zakupy pojawią się pod drzwiami",
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                }
            }
            admin.messaging().sendToDevice(userTokens, payload).then(() => { console.log("sent notification");}).catch((error) => {console.log(error);});
            }).catch((error) => {console.log(error);});
        }
    }
});

export const sendNotificationOnRequestPending = functions.firestore.document("/confirmRequests/{orderId}").onCreate((snapshot, context) => {
    const value = snapshot.data();
    console.log(value);
    if (value){
            console.log("new confirm request");
            const userTokensRef = admin.firestore().collection('users').doc(value.makerUid).collection('tokens');
            userTokensRef.get().then((userTokensSnap) => {
                const userTokens = userTokensSnap.docs.map((snap: any) => snap.id);
                const payload: admin.messaging.MessagingPayload = {
                notification:{
                    title: "Zamówienie czeka pod drzwiami",
                    body: "Wejdź do aplikacji żeby zaakceptować odbiór zamówienia",
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                }
            }
            admin.messaging().sendToDevice(userTokens, payload).then(() => { console.log("sent notification");}).catch((error) => {console.log(error);});
            }).catch((error) => {console.log(error);});
        
    }
});

export const remove = functions.firestore.document("/confirmRequests/{orderId}").onUpdate((change, context) => {
    const newValue = change.after.data();
    console.log(newValue);
    if (newValue){
        if (newValue.received == true){
            console.log("request received is true");
            const collection1Ref = admin.firestore().collection('users').doc(newValue.makerUid).collection('requests');
            const collection2Ref = admin.firestore().collection('users').doc(newValue.takerUid).collection('requests');
            
            collection1Ref.get().then((qs: any) =>{
                qs.forEach((docSnapshot: any) => {
                    docSnapshot.ref.delete().then(() => {
                        console.log("removed request from maker");
                    }).catch((error: any) => {
                        console.log(error);
                    });
                });
            }).catch((error: any) => {
                console.log(error);
            });
            
            collection2Ref.get().then((qs: any) =>{
                qs.forEach((docSnapshot: any) => {
                    docSnapshot.ref.delete().then(() => {
                        console.log("removed request from taker");
                    }).catch((error: any) => {
                        console.log(error);
                    });
                });
            }).catch((error: any) => {
                console.log(error);
            });
        }
    }
});