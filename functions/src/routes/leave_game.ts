import * as admin from 'firebase-admin';

export async function leave_game(req: any) {

    const data = req.data as { userId: string, email: string }; //infer the type of data
    const player_in_game = admin.database().ref(`/player_ingame/${data.userId}`);
    if (!(await player_in_game.get()).exists()) {
        return { error: "User is not in a game", result: null };
    }

    const gameId = (await player_in_game.get()).val();

    const game = admin.database().ref(`/games/${gameId}`);

    if (!(await game.get()).exists()) {
        return { error: "Game not found", result: null };
    }

    const players = game.child("players");
    const player = players.child(data.userId);
    if (!(await player.get()).exists()) {
        return { error: "Player not found", result: null };
    }

    await player.remove();
    if ((await players.get()).val() == null) {
        await game.remove();
    }

    await player_in_game.remove();
    return { result: "success" };



}