import * as admin from 'firebase-admin';
import { logger } from 'firebase-functions/v1';

export async function remove_party(req: any) {
    const party = admin.database().ref(`/games`);
    await party.remove();
    logger.log("Party cleared at " + new Date().toISOString());
}