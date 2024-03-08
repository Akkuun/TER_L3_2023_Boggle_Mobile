import { Game } from "../entity/game";
import { DictionariesHandler } from "./dictionnaries_handler";

export class GameHandler {

    constructor(private dictionariesHandler: DictionariesHandler) { }

    games: Map<string, Game> = new Map<string, Game>();

    async createGame(db: any, gameId: string, grid: string, lang: number) {
        const game = new Game(db, grid, this.dictionariesHandler.getDictionary(lang));
        game.Init();
        this.games.set(gameId, game);
    }

    getGame(gameId: string) {
        if (!this.games.has(gameId)) throw new Error("Game not found");

        return this.games.get(gameId) as Game;
    }

}
