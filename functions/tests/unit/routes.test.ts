import * as testInit from 'firebase-functions-test';
import * as admin from 'firebase-admin';
import { JoinGameReturn } from '../../src/enums/JoinGameReturn';

// Initialize test environment
const test = testInit(
    {
        databaseURL: 'https://bouggr-4bd2b-default-rtdb.europe-west1.firebasedatabase.app',
        storageBucket: 'bouggr-4bd2b.appspot.com',
        projectId: 'bouggr-4bd2b',
    },
    '../../private.json'
);

describe('Test CreateGame', () => {
    it('should create a game', (done) => {
        const create_game = require('../../src/index').CreateGame;
        const wrapped_create = test.wrap(create_game);
        const data = {
            data: {
                lang: 0,
                letters: 'test',
                name: 'test',
                email: 'test@test.test',
                userId: 'test',
            }
        };

        wrapped_create(data).then(async (result: { gameId: string }) => {
            expect(result.gameId).not.toBeNull();

            const game = admin.database().ref("/games").child(result.gameId);
            const gm = await game.get()
            expect(gm.exists()).toBe(true);
            gm.ref.remove();
            const player_in_game = admin.database().ref(`/player_ingame/${data.data.userId}`);
            const pg = await player_in_game.get()
            expect(pg.exists()).toBe(true);
            pg.ref.remove();

        }).catch((error: any) => {
            fail(error);
        }).finally(() => {
            done();
        });



    });

    it('should fail to create 2 identical games', (done) => {
        const create_game = require('../../src/index').CreateGame;
        const wrapped_create = test.wrap(create_game);
        const data = {
            data: {
                lang: 0,
                letters: 'test',
                name: 'test_d',
                email: 'test@testd.test',
                userId: 'test_d',
            }
        };

        wrapped_create(data).then(async (result: { gameId: string }) => {
            expect(result.gameId).not.toBeNull();
            wrapped_create(data).then(async (result: { gameId: string }) => {
                expect(result.gameId).toBeNull();
                const game = admin.database().ref("/games").child(data.data.userId);
                const gm = await game.get()
                expect(gm.exists()).toBe(false);
                const player_in_game = admin.database().ref(`/player_ingame/${data.data.userId}`);
                const pg = await player_in_game.get()
                expect(pg.exists()).toBe(false);
                done();
            })
        }).finally(() => {
            done();
        });
    });
});

describe('Test JoinGame', () => {
    it('should fail to found a game', (done) => {
        const join_game = require('../../src/index').JoinGame;
        const wrapped_join = test.wrap(join_game);

        const data = {
            data: {
                gameId: 'test_join_game',
                name: 'test_join_game',
                email: 'email',
                userId: 'test_join_game',
            }
        };

        wrapped_join(data).then(async (result: number) => {

            expect(result).toBe(JoinGameReturn.GAME_NOT_FOUND);


        }).finally(() => {
            const player_in_game = admin.database().ref(`/player_ingame/${data.data.userId}`);
            player_in_game.remove();
            done();
        });


    }
    );

});


describe('Test StartGame', () => {
    it('should start a game', (done) => {
        const create_game = require('../../src/index').CreateGame;
        const wrapped_create = test.wrap(create_game);
        const data = {
            data: {
                lang: 0,
                letters: 'test',
                name: 'test',
                email: 'zg',
                userId: 'test',
            }
        };
    });
});






test.cleanup();