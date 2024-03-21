import 'package:native_ffi/native_ffi.dart';
import 'package:test/test.dart';

void main() {
  test("test loadDico", () => expect(loadDictionary("test"), isNotNull));
}
