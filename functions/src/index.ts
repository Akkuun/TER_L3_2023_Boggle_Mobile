import { onCall } from "firebase-functions/v2/https";
// The Firebase Admin SDK to access the Firebase Realtime Database.
import * as admin from "firebase-admin";
import { JoinGameReturn } from "./enums/JoinGameReturn";
import { DictionariesHandler } from "./services/dictionnaries_handler";
import { LangCode, SendWordI, recreateWord } from "./utils/lang";

import { cert } from "firebase-admin/app";
import { log } from "firebase-functions/logger";
import { join_game } from "./routes/join_game";


// Initialize the Firebase Admin SDK
const serviceAccount = require("../private.json");

admin.initializeApp({
    credential: cert(serviceAccount),
    databaseURL: "https://bouggr-4bd2b-default-rtdb.europe-west1.firebasedatabase.app",
    storageBucket: "bouggr-4bd2b.appspot.com"
});


const DictionaryConfig = [
    {
        lang: LangCode.FR,
        path: "fr_dico.json"
    },

];

const dictionariesHandler = new DictionariesHandler(
    DictionaryConfig
);




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

    return gameId;
}
);


export const StartGame = onCall(async (req) => {

    const data = req.data as { gameId: string, userId: string };

    const game = admin.database().ref(`/games/${data.gameId}`);
    const gameData = await game.get();
    if (!gameData.exists()) {
        return false;
    }

    if (((await game.child("status").get()).val()) === "started") {
        return false;
    }

    const players = await game.child("players").get();
    if (players.exists()) {
        const playersData = players.val();
        if (playersData[data.userId].leader) {
            await game.update({ status: "started" });
            await game.push({ startedAt: Date.now() });

            return true;
        }
    }



    return false;
});


export const JoinGame = onCall(join_game);

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





export const SendWord = onCall(async (req) => {
    log("sendWord called with", req.data)
    const data = req.data as SendWordI;
    const game = admin.database().ref(`/games/${data.gameId}`);
    const gameData = await game.get();
    if (!gameData.exists()) {
        return 3;
    }

    log("gameData game found")

    const grid = (await game.child("letters").get()).val();
    const word = data.word;
    const wordStr = recreateWord(grid, word);

    log("wordStr", wordStr)


    const dico = dictionariesHandler.getDictionary((await game.child("lang").get()).val());

    //const checkWord = await game.child("players/" + data.userId + "/words").orderByChild("word").equalTo(wordStr).get();
    try {
        if (dico.contain(wordStr)) {
            await game.child("players/" + data.userId).push({ word: wordStr });

            return 0;
        }


        else {
            return 1;
        }
    } catch (e) {
        log("error", e)
        return 1;
    }
});