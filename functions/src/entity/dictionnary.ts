export class Dictionary {


  constructor(private graph: any[]) { };




  /// The function "contain" check if a string is in the dictionary
  public contain(word: string): boolean {
    let temp = this.graph;
    let count = word.length;
    for (const c of word) {
      const l: number = c.charCodeAt(0);
      count--;
      if (temp.length > 1) {
        const children = temp[1] as any[];
        // the current node has children

        let update = false;
        for (const element of children) {
          if (typeof (element) == 'number') {
            //is a leaf
            if ((element & ((1 << 8) - 1)) == l) {
              return count == 0 && (element & 0b100000000) > 0;
              //check if last letter of the word & if is completing a word
            }
          } else if ((element & 0b11111111) == l) {
            temp = element;
            update = true;
            break;
          }
        }
        if (!update) {
          return false;
        }
      } else {
        return false; // more letter than node for this word
      }
    }

    return (temp[0] & 0b100000000) > 0
  }


}
