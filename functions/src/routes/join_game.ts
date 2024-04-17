
import { JoinGameReturn } from "../enums/JoinGameReturn";
import * as admin from "firebase-admin";

export const join_game = async (req: { data: { userId: string; gameId: string; email: string; name: string }; }) => {
    const data = req.data as { userId: string, gameId: string, email: string, name: string }; //infer the type of data
    const player_in_game = admin.database().ref(`/player_ingame`);

    /**
     * Check if player is already in a game
     */
    const dataPlayerInGame = await player_in_game.child(data.userId).get();
    if (dataPlayerInGame.exists()) { //if player is in a game
        if (dataPlayerInGame.val() != data.gameId) {  //if game target is not same as player target
            return {
                code: JoinGameReturn.WRONG_GAME_ID, error: "Player already in game"
            };
        } else {
            return {
                code: JoinGameReturn.SUCCESS, error: null

            }
        }
    }


    /**
     * Check if game exists
     */
    const game = admin.database().ref(`/games/${data.gameId}`);
    const dataGame = await game.get();
    if (!dataGame.exists()) {
        return {
            code: JoinGameReturn.GAME_NOT_FOUND, error: `${data.gameId} not found`
        }
    }

    if ((await game.child("status").get()).val() === "started") {
        return {
            code: JoinGameReturn.GAME_STARTED, error: "Game already started"
        }
    }

    const gameData = await game.child("players").get();
    if (gameData.exists()) {
        const player = game.child("players/" + data.userId)
        if ((await player.get()).exists()) {
            return {
                code: JoinGameReturn.ALREADY_IN_GAME, error: `${((await player.get()).child("name").val() || "Player")
                    } already in game`
            };
        }
        await player.set({
            "name": data.name,
            "email": data.email,
            "score": 0,
            "leader": false
        });
        await player_in_game.child(data.userId).set(data.gameId);
        return {
            code: JoinGameReturn.SUCCESS, error: null
        };

    } else {
        return {
            code: JoinGameReturn.GAME_NOT_FOUND, error: `${data.gameId} not found`
        }
    }
}