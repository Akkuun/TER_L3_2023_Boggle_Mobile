
import { cert } from "firebase-admin/app";


import { DictionariesHandler } from "../../src/services/dictionnaries_handler";
import * as admin from "firebase-admin";

// Initialize test environment

const serviceAccount = require("../../private.json");

admin.initializeApp({
    credential: cert(serviceAccount),
    databaseURL: "https://bouggr-4bd2b-default-rtdb.europe-west1.firebasedatabase.app",
    storageBucket: "bouggr-4bd2b.appspot.com"
});

describe('Test dictionnary', () => {
    it('should has a dictionnary in the storage', (done) => {


        // Initialize the Firebase Admin SDK



        admin.storage().bucket().file("fr_dico.json").exists().then((exists) => {
            expect(exists[0]).toBe(true);
        }).then(() => {

            admin.storage().bucket().file("fr_dico.json").download().then((file) => {
                const dicoParsed = JSON.parse(file.toString());
                expect(dicoParsed[0]).toBe(79);

            });
        }).finally(() => {
            done();
        });


    });

    it('should add a dictionnary to the handler', (done) => {

        const DictionaryConfig = [
            {
                lang: 0,
                path: "fr_dico.json"
            },
        ];


        const dictionariesHandler = new DictionariesHandler();

        dictionariesHandler.init(DictionaryConfig).then(() => {

            expect(dictionariesHandler.dicoExists(0)).toBe(true);
            expect(dictionariesHandler.getDictionary(0)).not.toBeNull();
            expect(dictionariesHandler.getDictionary(0)?.contain("AAS")).toBe(true);

        }).finally(() => {
            done();
        });

    });
});