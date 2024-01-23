import 'dart:convert';
import 'dart:html';

import 'package:binary/binary.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:flutter/services.dart';

class Dictionary {
  final String path;
  final Decoded decoder;
  late List<dynamic>? dictionary;

  Dictionary({required this.path, required this.decoder});

  void load() async {
    final jsonString = await rootBundle.loadString(path);
    dictionary = jsonDecode(jsonString);
  }

  void unload() {
    dictionary = null;
  }

  bool contain(String word) {
    if (dictionary == null) {
      return false;
    }
    List<dynamic> temp = dictionary!;

    for (int l in word.runes) {
      if (temp.length > 1) {
        if (temp[1] is int) {
        } else {
          for (int i = 1; i < temp.length; i++) {
            if (temp[i] is int) {
              if (decoder.getRunesFrom(temp[i]) == Int8(l)) {}
            } else {
              if (decoder.getRunesFrom(temp[i][0]) == Int8(l)) {
                temp = temp[i][0];
              }
            }
          }
        }
      }
    }

    return false;
  }
}
