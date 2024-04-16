import * as admin from 'firebase-admin';
import { logger } from 'firebase-functions/v1';

export async function clear_player_list(req: any) {
    const player_ingame = admin.database().ref(`/player_ingame`);
    await player_ingame.remove();
    logger.log("Player list cleared at " + new Date().toISOString());
}