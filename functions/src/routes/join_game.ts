import { JoinGameReturn } from "../enums/JoinGameReturn";
import * as admin from "firebase-admin";

export const join_game = async (req: { data: { userId: string; gameId: string; email: string; name: string }; }) => {
    const data = req.data as { userId: string, gameId: string, email: string, name: string }; //infer the type of data
    const player_in_game = admin.database().ref(`/player_ingame/${data.userId}`);

    /**
     * Check if player is already in a game
     */
    const dataPlayerInGame = await player_in_game.get();
    if (dataPlayerInGame.exists()) { //if player is in a game
        if (dataPlayerInGame.val() != data.gameId) {  //if game target is not same as player target
            return JoinGameReturn.ALREADY_IN_GAME;
        } else {
            return JoinGameReturn.SUCCESS;
        }
    }


    /**
     * Check if game exists
     */
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
        await player.set({
            "name": data.name,
            "email": data.email,
            "score": 0,
            "leader": false
        });
        await player_in_game.set(data.gameId);
        return JoinGameReturn.SUCCESS;
    } else {
        return JoinGameReturn.GAME_NOT_FOUND;
    }
}