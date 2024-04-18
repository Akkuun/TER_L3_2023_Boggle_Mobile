
import { DictionariesHandler } from '../services/dictionnaries_handler';

// The Firebase Admin SDK to access the Firebase Realtime Database.
import * as admin from "firebase-admin";

import { SendWordI, recreateWord } from "../utils/lang";
import { GameState } from '../enums/gameState';
import { Dictionary } from '../entity/dictionnary';


export const check_word = (dictionariesHandler: { ptr: DictionariesHandler }, DictionaryConfig: any) => async (req: any) => {


    const data = req.data as SendWordI;
    const game = admin.database().ref(`/games/${data.gameId}`);
    const gameData = await game.get();
    if (!gameData.exists()) {
        return 3;
    }

    //game is started && player is in game && game is not finished
    if ((await game.child("status").get()).val() != GameState.InProgress) {
        return 2;
    }

    const player = game.child("players/" + data.userId);
    const playerData = await player.get();
    if (!playerData.exists()) {
        return 4;
    }

    const endTime = (await game.child("end_time").get()).val();
    if (endTime < Date.now()) {
        return 5;
    }




    const grid = (await game.child("letters").get()).val();
    const word = data.word;
    const wordStr = recreateWord(grid, word);



    const gameLang = (await game.child("lang").get()).val();
    if (!dictionariesHandler.ptr.dicoExists(gameLang)) {
        const file = await admin.storage().bucket().file(
            DictionaryConfig[gameLang].path).download()

        const dicoParsed = JSON.parse(file.toString());
        dictionariesHandler.ptr.addDictionary(gameLang, new Dictionary(dicoParsed));

    }
    const dico = dictionariesHandler.ptr.getDictionary(gameLang);
    if (dico == null) {
        return 101;
    }
    //const checkWord = await game.child("players/" + data.userId + "/words").orderByChild("word").equalTo(wordStr).get();
    try {
        if (dico.contain(wordStr)) {
            await game.child("players/" + data.userId).push({ word: wordStr });
            //update score
            const score = (await player.child("score").get()).val();
            player.update({ score: score + wordStr.length });

            return 0;
        }
        else {
            return {
                code: 1,
                error: "Word not found in dictionary",
                word: wordStr
            }
        }
    } catch (e) {

        return 100;
    }
}