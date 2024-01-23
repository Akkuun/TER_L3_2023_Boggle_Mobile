import 'package:bouggr/utils/decode.dart';
import 'package:bouggr/utils/dico.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('fun is in the dictionary', () async {
    Map<LangCode, int> lang = generateLangCode();
    Decoded decoder = Decoded(lang: lang);

    Dictionary dictionary =
        Dictionary(path: "assets/dictionary/global.json", decoder: decoder);

    await dictionary.load();

    expect(dictionary.contain("FUN"), true);
  });
}
