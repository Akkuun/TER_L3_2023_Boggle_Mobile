    const {onValueWritten,onValueCreated} = require("firebase-functions/v2/database");
const {logger} = require("firebase-functions");

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require("firebase-admin");


admin.initializeApp();
// Init firestore
const store = admin.firestore();

export const onNewGame = onValueCreated(
    {
        ref: "/games/{gameId}",
        instance: "bouggr-4bd2b-default-rtdb",
         region: "europe-west1"
    },
        async (event: any) => {
        
          store.collection("games").doc(event.params.gameId).set({
            gameId: event.params.gameId,
            createdAt: new Date().toISOString(),
            updatedAt: new Date().toISOString(),
            status: "created"
          });

        // create a new game

    }
    );
// Path: src/index.ts

export const onNewGameEdit = onValueWritten(
  {
    ref: "/games/{gameId}",
    instance: "bouggr-4bd2b-default-rtdb",
     region: "europe-west1"
  },
    async (event: any) => {
         store.collection("games").doc(event.params.gameId).set({
            gameId: event.params.gameId,
            createdAt: new Date().toISOString(),
            updatedAt: new Date().toISOString(),
            status: "created"
          });
       
       logger.info(`Game ${event} was edited`);
    }
);