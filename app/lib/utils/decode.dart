import 'package:native_ffi/native_ffi.dart';

class Decoded {
  static final Map<String, LangCode> stringLang = {
    'fr': LangCode.FR,
    'rm': LangCode.RM,
    'en': LangCode.EN,
    'sp': LangCode.SP,
    'global': LangCode.GLOBAL
  };
  final Map<LangCode, int> lang;

  Decoded({required this.lang});

  bool isEndingAWord(int code) {
    return endOfWorld(code);
  }

  bool isFrom(int code, LangCode langCode) {
    return code & lang[langCode]! > 0;
  }

  int getRunesFrom(int code) {
    return getChar(code);
  }

  static LangCode toLangCode(String code) {
    return Decoded.stringLang[code] ?? LangCode.FR;
  }
}

// ignore: constant_identifier_names
enum LangCode { FR, RM, EN, SP, GLOBAL }

String getLanguageName(LangCode langCode) {
  switch (langCode) {
    case LangCode.FR:
      return 'Français';
    case LangCode.EN:
      return 'Anglais';
    case LangCode.SP:
      return 'Espagnol';
    case LangCode.RM:
      return 'Roumain';
    case LangCode.GLOBAL:
      return 'Global';
    default:
      return '';
  }
}

Map<LangCode, int> generateLangCode() {
  Map<LangCode, int> res = {};
  int i = 9;
  for (LangCode lc in LangCode.values) {
    res[lc] = 1 << i;
    i++;
  }
  return res;
}
