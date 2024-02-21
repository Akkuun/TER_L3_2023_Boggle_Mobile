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

base class GoSlice extends Struct {
  external Pointer<Uint8> data;
  @Int32()
  external int len;
  @Int32()
  external int cap;

  List<int> toList() {
    final list = <int>[];
    for (var i = 0; i < len; i++) {
      list.add(data[i]);
    }
    return list;
  }
}
