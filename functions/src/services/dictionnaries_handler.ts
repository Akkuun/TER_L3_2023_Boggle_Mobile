import { Dictionary } from "../entity/dictionnary";
import * as admin from 'firebase-admin';
export interface DictionaryConfig {
    lang: number;
    path: string;
}

export class DictionariesHandler {

    constructor(
        dictionaries: DictionaryConfig[]
    ) {
        dictionaries.forEach((dico) => {
            admin.storage().bucket().file(dico.path).download().then((data) => {
                const dico = JSON.parse(data.toString());
                this.addDictionary(dico.lang, dico);
            });
        });
    }

    private dictionaries: Map<number, Dictionary> = new Map<number, Dictionary>();

    private addDictionary(lang: number, dictionary: Dictionary) {
        this.dictionaries.set(lang, dictionary);
    }

    public getDictionary(lang: number) {
        return this.dictionaries.get(lang) as Dictionary;
    }

    public dicoExists(lang: number) {
        return this.dictionaries.has(lang);
    }
}