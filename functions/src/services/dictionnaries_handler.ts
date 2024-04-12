import { Dictionary } from "../entity/dictionnary";

export class DictionariesHandler {

    constructor() { }

    private dictionaries: Map<number, Dictionary> = new Map<number, Dictionary>();

    public addDictionary(lang: number, dictionary: Dictionary) {
        this.dictionaries.set(lang, dictionary);
    }

    public getDictionary(lang: number) {
        return this.dictionaries.get(lang) as Dictionary;
    }
}