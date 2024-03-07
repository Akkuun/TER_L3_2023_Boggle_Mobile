import { Dictionary } from "../entity/dictionnary";

export class DictionariesHandler{

    private static dictionaries: Map<number, Dictionary> = new Map<number, Dictionary>();



    public static getDictionary(lang: number) {
        return this.dictionaries.get(lang) as Dictionary;
    }
}