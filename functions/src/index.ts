import { onCall } from "firebase-functions/v2/https";
// The Firebase Admin SDK to access the Firebase Realtime Database.
import * as admin from "firebase-admin";
import { DictionariesHandler } from "./services/dictionnaries_handler";
import { LangCode } from "./utils/lang";
import { check_word } from "./routes/check_word";
import { cert } from "firebase-admin/app";
import { join_game } from "./routes/join_game";
import { start_game } from "./routes/start_game";


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


//allow a player to start a game
export const StartGame = onCall(start_game);

//allow a player to join a game
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





export const SendWord = onCall(
    check_word(dictionariesHandler)
);