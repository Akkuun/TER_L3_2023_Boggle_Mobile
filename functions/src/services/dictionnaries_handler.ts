import { Dictionary } from "../entity/dictionnary";
import * as admin from 'firebase-admin';
export interface DictionaryConfig {
    lang: number;
    path: string;
}

export class DictionariesHandler {
    isReady: boolean = false;
    testValue: number = 0;

    public async init(dictionaries: DictionaryConfig[]) {

        for (const dictionary of dictionaries) {
            const file = await admin.storage().bucket().file(dictionary.path).download()

            const dicoParsed = JSON.parse(file.toString());
            this.addDictionary(dictionary.lang, new Dictionary(dicoParsed));

        }


    }

    private dictionaries: Map<number, Dictionary> = new Map<number, Dictionary>();

    private addDictionary(lang: number, dictionary: Dictionary) {
        this.dictionaries.set(lang, dictionary);
    }

    public getDictionary(lang: number) {
        return this.dictionaries.get(lang) ?? null;
    }

    public dicoExists(lang: number) {
        return this.dictionaries.has(lang);
    }
}