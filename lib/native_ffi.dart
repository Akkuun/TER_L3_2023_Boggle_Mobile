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

int getChar(int str) {
  return _bindings.GetChar(str);
}

bool isSameKey(String key1, int key2) {
// Convert the Dart string to a C string.
  final key1Ptr = key1.toNativeUtf8();
  try {
    return _bindings.IsSameKey(key1Ptr as Pointer<Char>, key2) == 1;
  } finally {
    // Free the C string.
    calloc.free(key1Ptr);
  }
}

bool endOfWorld(int value) {
  return _bindings.EndOfWord(value) == 1;
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
