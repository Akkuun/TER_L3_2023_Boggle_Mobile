import * as admin from "firebase-admin";
import { GameState } from "../enums/gameState";

interface User {
    name: string,
    email: string,
    score: number,
    leader: boolean,
}

interface GameInterface {
    status: GameState;
    players: { [key: string]: User };
    letters: string;
    lang: number;
}


export async function create_game(req: any) {
    const data = req.data as {
        userId: string, email: string, letters: string, lang: number
        name: string,
    };
    //add user to player_ingame
    const player_ingame = admin.database().ref(`/player_ingame/${data.userId}`);


    if ((await player_ingame.get()).exists()) {
        //if the game is not found in the database
        const game = admin.database().ref(`/games/${(await player_ingame.get()).val()}`);
        if (!(await game.get()).exists()) {
            await player_ingame.remove();

        } else if ((await game.child("status").get()).val() == GameState.Finished) {
            await player_ingame.remove();
        } else if ((await game.child("end_time").get()).val() < Date.now()) {

            await game.remove();
            await player_ingame.remove();
        } else {
            return { gameId: null, error: "Player already in game" };

        }




    }

    const game = admin.database().ref("/games").push();
    const gameId = game.key as string;


    const payload: GameInterface = {
        "status": GameState.NotStarted,
        "letters": data.letters,
        "players": {
            [data.userId]: {
                "name": data.name,
                "email": data.email,
                "score": 0,
                "leader": true
            }
        },
        "lang": data.lang,
    };

    await game.set(payload);
    await player_ingame.set(gameId);
    return { gameId: gameId }
}