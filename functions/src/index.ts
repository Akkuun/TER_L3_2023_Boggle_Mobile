import { onCall } from "firebase-functions/v2/https";
import { onSchedule } from "firebase-functions/v2/scheduler";
// The Firebase Admin SDK to access the Firebase Realtime Database.
import * as admin from "firebase-admin";
import { DictionariesHandler } from "./services/dictionnaries_handler";
import { LangCode } from "./utils/lang";
import { check_word } from "./routes/check_word";
import { cert } from "firebase-admin/app";
import { join_game } from "./routes/join_game";
import { start_game } from "./routes/start_game";
import { create_game } from "./routes/create_game";
import { leave_game } from "./routes/leave_game";
import { cancel_game } from "./routes/cancel_game";
import { remove_party } from "./cron_task/remove_party";
import { clear_player_list } from "./cron_task/clear_player_list";


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



export const CronClearGames = onSchedule("every day 05:00", remove_party);

export const CronClearPlayerList = onSchedule("every day 05:00", clear_player_list);

export const CreateGame = onCall(create_game);

//allow a player to start a game
export const StartGame = onCall(start_game);

//allow a player to join a game
export const JoinGame = onCall(join_game);

export const LeaveGame = onCall(leave_game);


export const CancelGame = onCall(cancel_game);


export const SendWord = onCall(
    check_word(dictionariesHandler)
);