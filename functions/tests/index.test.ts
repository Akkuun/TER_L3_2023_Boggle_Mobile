import { recreateWord } from '../src/utils/lang';

describe('Test assert test environment', () => {
    it('should pass', () => {
        expect(true).toBe(true);
    });
});


describe('Test recreate word', () => {
    it('should return "test" from coords', () => {
        const grid = "test";
        const coords = [{ x: 0, y: 0 }, { x: 1, y: 0 }, { x: 2, y: 0 }, { x: 3, y: 0 }];
        expect(recreateWord(grid, coords)).toBe("test");
    });
});