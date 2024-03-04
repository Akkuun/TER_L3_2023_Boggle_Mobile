
import { Dictionary } from "./dictionnary";


export class Game {
  private isStarted = false;
  private timerUntilShutdown = 100;

  constructor(
    private timer: number,
    private grid: string[],
    private playerIds: string[],
    private dico : Dictionary
  ) {}

  public Start() {
    this.isStarted = true;
    this.timerUntilShutdown = 100;
  }

  public get IsStarted() {
    return this.isStarted;
  }

  public DecressTimerUntilShutdown(): number {
    this.timerUntilShutdown--;
    return this.timerUntilShutdown;
  }

  public ShutDown() {
    // remove from bdd & send message

  }

  public DecressTimer() :boolean {
    
    this.timer--;

    return this.timer == 0;
  }
  
  private recreateWord(word : number[]) :string {
    let res = "";
    let lastPos = null;
    while (word.length > 0) {
      if (lastPos == null) {
        res += this.grid[word[0]];
        lastPos = word[0];
        word = word.slice(1);
      } else {
        let found = false;
        for (let i = 0; i < word.length; i++) {
          if (Math.abs(lastPos - word[i]) == 1) {
            res += this.grid[word[i]];
            lastPos = word[i];
            word = word.slice(0, i).concat(word.slice(i+1));
            found = true;
            break;
          }
        }
        if (!found) {
          return "";
        }
      }
    }


    return res;
  }


  public checkWord(input : number[]) :boolean{
    const word = this.recreateWord(input);
    return this.dico.contain(word);
  }
}


