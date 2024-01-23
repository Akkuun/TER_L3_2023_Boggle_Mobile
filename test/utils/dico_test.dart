import 'package:bouggr/utils/decode.dart';
import 'package:bouggr/utils/dico.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("unit test for dictionary", () async {
    Map<LangCode, int> lang = generateLangCode();
    Decoded decoder = Decoded(lang: lang);

    Dictionary dictionary =
        Dictionary(path: "assets/dictionary/global.json", decoder: decoder);

    await dictionary.load();
    test('fun is in the dictionary', () {
      expect(dictionary.contain("FUN"), true);
    });

    test('ZEFOB is not in the dictionary', () {
      expect(dictionary.contain("ZEFOB"), false);
    });
  });
}
