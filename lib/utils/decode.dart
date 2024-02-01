import 'package:binary/binary.dart';

class Decoded {
  final Map<LangCode, int> lang;

  Decoded({required this.lang});

  bool isEndingAWord(int code) {
    return code & (1 << 8) > 0;
  }

  bool isFrom(int code, LangCode langCode) {
    return code & lang[langCode]! > 0;
  }

  Int8 getRunesFrom(int code) {
    return Int8(code & ((1 << 8) - 1));
  }
}

enum LangCode { FR, RM, EN, SP }

Map<LangCode, int> generateLangCode() {
  Map<LangCode, int> res = {};
  int i = 9;
  for (LangCode lc in LangCode.values) {
    res[lc] = 1 << i;
    i++;
  }
  return res;
}
