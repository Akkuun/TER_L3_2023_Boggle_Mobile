
import { DictionariesHandler } from '../services/dictionnaries_handler';

// The Firebase Admin SDK to access the Firebase Realtime Database.
import * as admin from "firebase-admin";

import { SendWordI, recreateWord } from "../utils/lang";

import { log } from "firebase-functions/logger";


export const check_word = (dictionariesHandler: DictionariesHandler) => async (req: any) => {
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
}