import { JoinGameReturn } from "../enums/JoinGameReturn";
import * as admin from "firebase-admin";

export const join_game = async (req: { data: { userId: string; gameId: string; email: string; }; }) => {
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
}