export enum LangCode { FR, RM, EN, SP, GLOBAL }

export interface CoordsI {
    x: number;
    y: number;
}

export interface SendWordI {
    gameId: string;
    userId: string;
    word: CoordsI[];
}

export function recreateWord(grid: string, coords: CoordsI[]) {
    return coords.map((c: CoordsI) => grid[c.x + c.y * 4]).join("");
}

