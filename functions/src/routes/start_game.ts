import * as admin from "firebase-admin";

import { GameState } from "../enums/gameState";



enum StartGameReturn {
    SUCCESS = 0,
    GAME_NOT_FOUND = 1,
    GAME_STARTED = 2,
    NOT_LEADER = 3,
    NOT_IN_GAME = 4,
    ALREADY_IN_PROGRESS = 5,
    WRONG_GAME_ID = 6
}

export async function start_game(req: any) {

    const data = req.data as { gameId: string, userId: string };

    const player_ingame = admin.database().ref(`/player_ingame/${data.userId}`);
    const playerInGameData = await player_ingame.get();
    if (!playerInGameData.exists()) { //if player is not in a game
        return StartGameReturn.NOT_IN_GAME;
    }

    if ((playerInGameData.val()) != data.gameId) { //if game target is not same as player target
        return StartGameReturn.WRONG_GAME_ID;
    }


    const game = admin.database().ref(`/games/${data.gameId}`);
    const gameData = await game.get();
    if (!gameData.exists()) { //if game does not exist
        return StartGameReturn.GAME_NOT_FOUND;
    }

    const players = await game.child("players");
    const targetPlayer = players.child(data.userId);
    if (!(await targetPlayer.get()).exists()) { // if player does not exist
        return StartGameReturn.NOT_IN_GAME;
    } else {
        if (!(await targetPlayer.child("leader").get()).val()) { //if player is not a leader
            return StartGameReturn.NOT_LEADER;
        }
    }

    // player exist in the game & is a leader
    if ((await game.child("status").get()).val() != GameState.NotStarted) { //game already started
        return StartGameReturn.ALREADY_IN_PROGRESS;
    }

    await game.update({ status: GameState.InProgress });
    // 3min game
    const start = Date.now();
    await game.push({ startedAt: start });
    await game.push({ end_time: start + 180000 });

    return StartGameReturn.SUCCESS;
}