import * as testInit from 'firebase-functions-test';
import * as admin from 'firebase-admin';
import { JoinGameReturn } from '../../src/enums/JoinGameReturn';
const create_game = require('../../src/index').CreateGame;
const join_game = require('../../src/index').JoinGame;
const start_game = require('../../src/index').StartGame;
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

        const wrapped_create = test.wrap(create_game);
        const data = {
            data: {
                lang: 0,
                letters: 'OVERFCEANAEBRUAS',
                name: 'test_d',
                email: 'test@testd.test',
                userId: 'test_d',
            }
        };
        let saveGameId: string = '';
        wrapped_create(data).then(async (result: { gameId: string }) => {
            expect(result.gameId).not.toBeNull();
            saveGameId = result.gameId;
            wrapped_create(data).then(async (result: { gameId: string }) => {
                expect(result.gameId).toBeNull();
                const game = admin.database().ref("/games").child(data.data.userId);
                const gm = await game.get()

                expect(gm.exists()).toBe(false);
                const player_in_game = admin.database().ref(`/player_ingame/${data.data.userId}`);
                const pg = await player_in_game.get()
                expect(pg.exists()).toBe(false);


            })
        }).finally(() => {
            const firstGame = admin.database().ref("/games").child(saveGameId);
            firstGame.remove();
            const firstPlayer = admin.database().ref(`/player_ingame/${data.data.userId}`);
            firstPlayer.remove();
            done();
        });
    });
});

describe('Test JoinGame', () => {
    it('should fail to found a game', (done) => {

        const wrapped_join = test.wrap(join_game);

        const data = {
            data: {
                gameId: 'test_join_game',
                name: 'test_join_game',
                email: 'email',
                userId: 'test_join_game',
            }
        };

        wrapped_join(data).then(async (result: any) => {

            expect(result.code).toBe(JoinGameReturn.GAME_NOT_FOUND);


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

        const wrapped_create = test.wrap(create_game);

        const wrapped_start = test.wrap(start_game);
        const wrapped_join = test.wrap(join_game);

        const data = {
            data: {
                lang: 0,
                letters: 'OVERFCEANAEBRUAS',
                name: 'test_start_game_1',
                email: 'zg',
                userId: 'test_start_game_1',
            }
        };
        let gameId: string = '';

        wrapped_create(data).then(async (result: { gameId: string }) => {
            expect(result.gameId).not.toBeNull();
            gameId = result.gameId;
            const join_data = {
                data: {
                    gameId: gameId,
                    name: 'test_start_game_2',
                    email: 'email',
                    userId: 'test_start_game_2',
                }
            };

            wrapped_join(join_data).then(async (result: any) => {
                expect(result.code).toBe(JoinGameReturn.SUCCESS);


                const start_data = {
                    data: {
                        gameId: gameId,
                        userId: 'test_start_game_1',
                    }
                };
                wrapped_start(start_data).then(async (result: any) => {
                    expect(result).toBe(0);
                    const game = admin.database().ref("/games").child(gameId);
                    const gm = await game.get()
                    expect(gm.exists()).toBe(true);
                    expect(gm.val().status).toBe(0);
                    gm.ref.remove();
                    const player_in_game = admin.database().ref(`/player_ingame/${data.data.userId}`);
                    const pg = await player_in_game.get()
                    expect(pg.exists()).toBe(true);
                    const player_in_game2 = admin.database().ref(`/player_ingame/${join_data.data.userId}`);
                    const pg2 = await player_in_game2.get()
                    expect(pg2.exists()).toBe(true);
                    pg2.ref.remove();


                    pg.ref.remove();
                    done();
                });
            })
        });
    });

});

/*
describe('Test CheckWord', () => {
    it('should check a word', (done) => {
        const check_word = require('../../src/index').CheckWord;
        const wrapped_check = test.wrap(check_word);

        const data = {
            data: {
                gameId: 'test',
                userId: 'test',
                word: 'test',
            }
        };
        wrapped_check(data).then(async (result: any) => {
            expect(result).toBe(true);
        }).finally(() => {
            done();
        });
    });
});


*/




test.cleanup();