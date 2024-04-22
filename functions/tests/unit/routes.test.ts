import * as testInit from 'firebase-functions-test';
import * as admin from 'firebase-admin';
import { JoinGameReturn } from '../../src/enums/JoinGameReturn';


const create_game = require('../../src/index').CreateGame;
const join_game = require('../../src/index').JoinGame;
const start_game = require('../../src/index').StartGame;
const check_word = require('../../src/index').SendWord;
const leave_game = require('../../src/index').LeaveGame;

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


    it("can create a game if the last one is finished", (done) => {
        //TODO
        expect(false).toBe(true);
        done();
    });

    it("can create a game if the last one is not found", (done) => {
        //TODO
        expect(false).toBe(true);
        done();
    });

    it("can't create a game if the last one is in progress", (done) => {
        //TODO
        expect(false).toBe(true);

        //should return the game id
        done();
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

    it('should join a game', (done) => {

        admin.database().ref("/games").push({
            status: 3,
            players: {
                test_2_join_game: {
                    name: 'test_2_join_game',
                    email: 'email',
                    score: 0,
                    leader: true
                }
            },
            letters: 'test',
            lang: 0
        }).then(async (game) => {


            const wrapped_join = test.wrap(join_game);

            const data = {
                data: {
                    gameId: game.key,
                    name: 'test_2_join_game_2',
                    email: 'email',
                    userId: 'test_2_join_game_2',
                }
            };

            const result = await wrapped_join(data)
            expect(result.code).toBe(JoinGameReturn.SUCCESS);
            game.ref.remove();
            const player_in_game = admin.database().ref(`/player_ingame/${data.data.userId}`);
            player_in_game.remove();
        }).finally(() => {
            done();
        });
    });

    it("should not be able to join a game if the game is not in waiting", (done) => {
        //TODO
        expect(false).toBe(true);
        done();
    });


    it("should join back a game if he disconnect ", (done) => {
        //TODO
        expect(false).toBe(true);
        done();
    });


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


    it("should be able to start a game if the leader leaves", (done) => {
        //TODO
        expect(false).toBe(true);
        done();
    });

    it("should be able to start a game if the leader cancels", (done) => {
        expect(false).toBe(true);
        done();
    });

    it("should not be able to start a game if the game is already started", (done) => {
        //TODO
        expect(false).toBe(true);
        done();
    });



});



describe('Test CheckWord', () => {
    it('AAS should be in the grid', (done) => {

        const wrapped_check = test.wrap(check_word);
        const wrapped_create = test.wrap(create_game);
        const wrapped_start = test.wrap(start_game);
        const wrapped_join = test.wrap(join_game);

        const data = {
            data: {
                lang: 0,
                letters: 'OVERFCEANAEBRUAS',
                name: 'test_check_game_1',
                email: 'zg',
                userId: 'test_check_game_1',
            }
        };
        let gameId: string = '';

        wrapped_create(data).then(async (result: { gameId: string }) => {
            expect(result.gameId).not.toBeNull();
            gameId = result.gameId;
            const join_data = {
                data: {
                    gameId: gameId,
                    name: 'test_check_game_2',
                    email: 'email',
                    userId: 'test_check_game_2',
                }
            };

            wrapped_join(join_data).then(async (result: any) => {
                expect(result.code).toBe(JoinGameReturn.SUCCESS);


                const start_data = {
                    data: {
                        gameId: gameId,
                        userId: 'test_check_game_1',
                    }
                };
                wrapped_start(start_data).then(async (result: any) => {
                    expect(result).toBe(0);

                    const check_data = {
                        data: {
                            gameId: gameId,
                            userId: 'test_check_game_1',
                            str: 'AAS',
                            word: [
                                { x: 1, y: 2 },
                                { x: 2, y: 3 },
                                { x: 3, y: 3 },
                            ]

                        }
                    };
                    wrapped_check(check_data).then(async (result: any) => {
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


                    }).finally(() => {
                        const game = admin.database().ref("/games").child(gameId);
                        game.remove();
                        done();
                    });
                })
            });
        })
    }, 10000);

    it("should not be able to check a word if the game is not started", (done) => {
        //TODO
        expect(false).toBe(true);
        done();
    });

    it("should not be able to check a word if the game is finished", (done) => {
        //TODO
        expect(false).toBe(true);
        done();
    });

});


describe('Test Cancel Game', () => {
    it('should cancel a game', (done) => {
        //TODO
        expect(false).toBe(true);
        done();
    });

    it('should not cancel a game if not the leader', (done) => {
        //TODO
        expect(false).toBe(true);
        done();
    });
})

describe('Test Leave Game', () => {

    it('should leave a game', (done) => {
        const warpped_leave = test.wrap(leave_game);
        //create a fake game and fake player
        let gameId: string = '';
        admin.database().ref("/games").push({
            status: 3,
            players: {
                test_2_leave_game: {
                    name: 'test_2_leave_game',
                    email: 'email',
                    score: 0,
                    leader: true
                },
                dump: {
                    name: 'test_dump_leave_game',
                    email: 'email',
                    score: 0,
                    leader: true
                }
            },
            letters: 'test',
            lang: 0
        }).then(async (game) => {
            expect(game.key).not.toBeNull();
            admin.database().ref(`/player_ingame/test_2_leave_game`).set(game.key);
            const data = {
                data: {
                    userId: 'test_2_leave_game',
                    email: 'email'
                }
            };
            gameId = game.key ?? '';
            warpped_leave(data).then(async (result: any) => {
                expect(result.result).toBe("success");
                const game = admin.database().ref("/games").child(gameId);
                const gm = await game.get()
                expect(gm.exists()).toBe(true); // not last player
                gm.ref.remove();
                const player_in_game = admin.database().ref(`/player_ingame/${data.data.userId}`);
                const pg = await player_in_game.get()
                expect(pg.exists()).toBe(false);
            }).finally(() => {
                done();
            });
        });



    });

    it("should delete the game if the last player leaves", (done) => {
        //TODO
        expect(false).toBe(true);
        done();
    });

    it("should change the leader if the leader leaves", (done) => {
        //TODO
        expect(false).toBe(true);
        done();
    });


});


test.cleanup();