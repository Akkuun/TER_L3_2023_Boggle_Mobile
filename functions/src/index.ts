import { Game } from "fivem-js";
import { GameHandler } from "./services/game_handler";

    const {onValueCreated} = require("firebase-functions/v2/database");
const {logger} = require("firebase-functions");
const {onRequest} = require("firebase-functions/v2/https");
// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require("firebase-admin");


admin.initializeApp();
// Init firestore


//cron task to remove games after 10 minutes

export const CreateGame = onRequest(async (req : any, res:any) => {
    const data = req.body;
    const game = admin.database().ref("/games").push();
    const gameId = game.key;
    game.set({
        status: "waiting",
        players: [data.userId],
        creator: data.userId,
        gameId,
        createdAt: Date.now()
    });

    const db = admin.database().ref(`/games/${gameId}`);

    GameHandler.createGame(db,gameId, data.grid, data.lang);

    res.status(200).send(gameId);
}
);


export const StartGame = onRequest(async (req : any, res:any) => {
    const data = req.body;

   

    const game =  GameHandler.getGame(data.gameId);
    const gameData = await game.Data;
    if (gameData.status === "started") {
        res.status(400).send("Game already started");
    } else {
        if (gameData.players.length <2) {
            res.status(400).send("Not enough players");
        } else {
            // start game
            game.Start();

            res.status(200).send("Game started");
        }
    }
}
);


export const JoinGame = onRequest(async (req : any, res:any) => {
    const data = req.body;
    const game = admin.database().ref(`/games/${data.gameId}`);
    const gameData = await game.get();
    if (gameData.status === "started") {
        res.status(400).send("Game already started");
    } else {
        if (gameData.players.length >= 10) {
            res.status(400).send("Game full");
        } else {
            // join game
            game.update({players: [...gameData.players, data.userId]});

            res.status(200).send("Game joined");
        }
    }
});

export const LeaveGame = onRequest(async (req : any, res:any) => {
    const data = req.body;
    const game = admin.database().ref(`/games/${data.gameId}`);
    const gameData = await game.get();
    if (gameData.status === "started") {
        res.status(400).send("Game already started");
    } else {
        // leave game
        game.update({players: gameData.players.filter((player: string) => player !== data.userId)});

        res.status(200).send("Game left");
    }
});


export const sendWord = onRequest(async (req : any, res:any) => {
    const data = req.body;
    const game = admin.database().ref(`/games/${data.gameId}`);
    const gameData = await game.get();
    if (gameData.status === "started") {
        res.status(400).send("Game already started");
    } else {
        // leave game
        game.update({word: data.word});

        res.status(200).send("Word sent");
    }
});