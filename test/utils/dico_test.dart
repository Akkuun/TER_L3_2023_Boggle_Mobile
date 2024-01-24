import 'package:bouggr/utils/decode.dart';
import 'package:bouggr/utils/dico.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("unit test for dictionary", () {
    Map<LangCode, int> lang = generateLangCode();
    Decoded decoder = Decoded(lang: lang);

    Dictionary dictionary =
        Dictionary(path: "assets/dictionary/global.json", decoder: decoder);

    dictionary.load();
    test('FUN is in the dictionary', () {
      expect(dictionary.contain("FUN"), true);
    });

    test('ZEFOB is not in the dictionary', () {
      expect(dictionary.contain("ZEFOB"), false);
    });

    test('BA can be completed', () {
      expect(dictionary.canCreate("BA"), true);
    });

    test("ZZ can't be completed", () {
      expect(dictionary.canCreate("ZZ"), false);
    });
  });
}
