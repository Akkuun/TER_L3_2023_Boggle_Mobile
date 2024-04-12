import 'package:bouggr/utils/decode.dart';

class Language {
  final String _code;
  final String _name;
  final LangCode _langCode;

  const Language(this._code, this._name, this._langCode);

  String get code {
    return _code;
  }

  String get name {
    return _name;
  }

  LangCode get langCode {
    return _langCode;
  }
}
