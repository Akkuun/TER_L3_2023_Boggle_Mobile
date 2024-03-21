import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'dart:io';

import 'generated_bindings.dart';

/// A very short-lived native function.
///
/// For very short-lived functions, it is fine to call them on the main isolate.
/// They will block the Dart execution while running the native function, so
/// only do this for native functions which are guaranteed to be short-lived.
int sum(int a, int b) => _bindings.sum(a, b);

class NativeStringArray {
  final Pointer<Pointer<Char>> ptr;
  final int length;

  NativeStringArray(this.ptr, this.length);

  List<String> toList() {
    final List<String> result = [];
    for (var i = 0; i < length; i++) {
      result.add((ptr + i).value.cast<Char>().toString());
    }
    return result;
  }

  String get(int index) {
    if (index < 0 || index >= length) throw RangeError("Index out of range");
    return (ptr + index).value.cast<Char>().toString();
  }

  free() {
    _bindings.FreeCStringArray(ptr, length);
  }
}

Pointer<Void> loadDictionary(String path) {
  //path to Pointer<Char>
  //convert path to pointer<Char>
  final Pointer<Char> pathPtr = path.toNativeUtf8().cast<Char>();

  return _bindings.LoadDico(pathPtr);
}

void freeDictionary(Pointer<Void> dico) {
  _bindings.FreeDico(dico);
}

bool checkWord(Pointer<Void> dico, String word) {
  //word to Pointer<Char>
  //convert word to pointer<Char>
  final Pointer<Char> wordPtr = word.toNativeUtf8().cast<Char>();

  return _bindings.CheckWord(wordPtr, dico) == 1;
}

NativeStringArray getAllWords(String grid, Pointer<Void> dico) {
  //grid to Pointer<Char>
  //convert grid to pointer<Char>
  final Pointer<Char> gridPtr = grid.toNativeUtf8().cast<Char>();

  var n = calloc<Int>();
  n.value = 0;
  var ptr = _bindings.GetAllWord(gridPtr, dico, n);
  print("success get all words ${n.value}");
  return NativeStringArray(ptr, n.value);
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
