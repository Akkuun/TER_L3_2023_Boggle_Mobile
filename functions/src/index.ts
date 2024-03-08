
import { GameHandler } from "./services/game_handler";

import { onCall } from "firebase-functions/v2/https";
// The Firebase Admin SDK to access the Firebase Realtime Database.
import * as admin from "firebase-admin";
import { JoinGameReturn } from "./enums/JoinGameReturn";


admin.initializeApp();
// Init firestore

interface User {
    email: string,
    score: number,
    leader: boolean,
}

interface GameInterface {
    status: string;
    players: { [key: string]: User };
    letters: string;
    lang: number;
}



//cron task to remove games after 10 minutes



export const CreateGame = onCall(async (req) => {
    const data = req.data as { userId: string, email: string, letters: string, lang: number };
    const game = admin.database().ref("/games").push();
    const gameId = game.key as string;


    const payload: GameInterface = {
        "status": "created",
        "letters": data.letters,
        "players": {
            [data.userId]: {
                "email": data.email,
                "score": 0,
                "leader": true
            }
        },
        "lang": data.lang,
    };

    await game.set(payload);




    const db = admin.database().ref(`/games/${gameId}`);

    GameHandler.createGame(db, gameId, data.letters, data.lang);

    return gameId;
}
);


export const StartGame = onCall(async (req) => {
    const data = req.data;



    const game = GameHandler.getGame(data.gameId);
    const gameData = await game.Data;
    if (gameData.status === "started") {
        return "Game already started";
    } else {
        if (gameData.players.length < 2) {
            return "Not enough players";
        } else {
            // start game
            game.Start();

            return "Game started";
        }
    }
}
);


export const JoinGame = onCall(async (req) => {
    const data = req.data as { userId: string, gameId: string, email: string };
    const game = admin.database().ref(`/games/${data.gameId}`);
    const dataGame = await game.get();
    if (!dataGame.exists()) {
        return JoinGameReturn.GAME_NOT_FOUND;
    }

    if ((await game.child("status").get()).val() === "started") {
        return JoinGameReturn.GAME_STARTED;
    }

    const gameData = await game.child("players").get();
    if (gameData.exists()) {
        const player = game.child("players/" + data.userId)
        if ((await player.get()).exists()) {
            return JoinGameReturn.ALREADY_IN_GAME;
        }
        player.set({
            "email": data.email,
            "score": 0,
            "leader": false
        });
        return JoinGameReturn.SUCCESS;
    } else {
        return JoinGameReturn.GAME_NOT_FOUND;
    }
});

export const LeaveGame = onCall(async (req) => {
    const data = req.data;
    const game = admin.database().ref(`/games/${data.gameId}`);
    const gameData: any = await game.get();
    if (gameData.status === "started") {
        return "Game already started";
    } else {
        // leave game
        game.update({ players: gameData.players.filter((player: string) => player !== data.userId) });

        return "Game left";
    }
});


export const sendWord = onCall(async (req) => {
    const data = req.data;
    const game = admin.database().ref(`/games/${data.gameId}`);
    const gameData: any = await game.get();
    if (gameData.status === "started") {
        return "Game already started";
    } else {
        // leave game
        game.update({ word: data.word });
        return "Word sent";
    }
});