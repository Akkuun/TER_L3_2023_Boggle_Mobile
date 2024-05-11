import { recreateWord } from '../src/utils/lang';

describe('Test assert test environment', () => {
    it('should pass', (done) => {
        expect(true).toBe(true);
        done();
    });
});


describe('Test recreate word', () => {
    it('should return "test" from coords', (done) => {
        const grid = "test";
        const coords = [{ x: 0, y: 0 }, { x: 1, y: 0 }, { x: 2, y: 0 }, { x: 3, y: 0 }];
        expect(recreateWord(grid, coords)).toBe("test");
        done();
    });

});