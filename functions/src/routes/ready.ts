
import * as admin from 'firebase-admin';
import { Game } from 'fivem-js';
import { GameState } from '../enums/gameState';


enum readyResponse {
    NOT_IN_GAME,
    GAME_NOT_FOUND,
}

export async function ready(req: any) {
    // check if the player id is valid and exists in the game
    // get the player id from the request
    const userId = req.data.userId;
    const user = admin.database().ref(`/player_ingame/${userId}`);
    if (!(await user.get()).exists()) {
        return { code: readyResponse.NOT_IN_GAME, error: "User is not in a game" };
    }

    // get the game id from the request
    const gameId = req.data.gameId;

    const game = admin.database().ref(`/games/${gameId}`);


    if (
        !(await game.get()).exists()) {
        return { code: readyResponse.GAME_NOT_FOUND, error: "Game not found" };
    }



    // should check if the player is already ready (if yes then do nothing)
    if ((await game.child("players/" + userId + "/ready").get()).val() && true) {
        return;
    }

    // set the player to ready
    game.child("players/" + userId).update({
        ready: true
    });

    //update ready count
    const readyCount = game.child("readyCount");
    readyCount.transaction((currentData) => {
        return currentData + 1;
    });

    // if ready count is equal to the number of player then start the game
    const gameData = await game.child("players").get();
    if (gameData.exists()) {
        const players = gameData.val();
        const playerCount = Object.keys(players).length;
        if (playerCount == (await readyCount.get()).val()) {
            game.update({
                state: GameState.InProgress,
                endTime: Date.now() + 60000,
                startTime: Date.now()
            });
        }
    }


    // set the game state to 'started'
    // set the end time of the game
    // set the start time of the game

    // client should not expect any response from this route but look for the real-time updates
}