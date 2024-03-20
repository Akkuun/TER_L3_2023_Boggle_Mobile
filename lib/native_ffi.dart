import 'dart:async';
import "dart:convert";
import 'dart:ffi';
import 'dart:io';

import 'generated_bindings.dart';

/// A very short-lived native function.
///
/// For very short-lived functions, it is fine to call them on the main isolate.
/// They will block the Dart execution while running the native function, so
/// only do this for native functions which are guaranteed to be short-lived.
int sum(int a, int b) => _bindings.sum(a, b);

Future<Array<String>> GetAllWords(String grid, dynamic dico) {
  //grid to Pointer<Char>
  final Pointer<Char> gridPtr = utf8.encode(grid).cast<Char>() as Pointer<Char>;

  final res = _bindings.GetAllWord(gridPtr, dico);

  //convert Pointer<Pointer<Char>> to List<String>
  final List<String> words = [];
  for (int i = 0; i < res.length; i++) {
    words.add(res[i].cast<Utf8>().toDartString());
  }
  return words;
}

const String _libName = 'native_ffi';

/// The dynamic library in which the symbols for [NativeAddBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('libsum.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final NativeLibrary _bindings = NativeLibrary(_dylib);
