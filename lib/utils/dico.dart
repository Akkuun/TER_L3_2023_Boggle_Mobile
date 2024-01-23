import 'dart:convert';

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
    int count = word.length;
    for (final l in word.runes) {
      count--;
      if (temp.length > 1) {
        // the current node has children
        if (temp[1] is int) {
          // is a leaf
          return count == 0 && decoder.isEndingAWord(temp[1]);
          //check if last letter of the word & if is completing a word
        } else {
          for (int i = 1; i < temp.length; i++) {
            if (temp[i] is int) {
              //is a leaf
              if (decoder.getRunesFrom(temp[i]) == Int8(l)) {
                return count == 0 && decoder.isEndingAWord(temp[i]);
                //check if last letter of the word & if is completing a word
              }
            } else {
              if (decoder.getRunesFrom(temp[i][0]) == Int8(l)) {
                temp = temp[i][0];
              }
            }
          }
        }
      } else {
        return false; // more letter than node for this word
      }
    }

    return decoder.isEndingAWord(temp[0]);
  }

  bool canCreate(String word) {
    if (dictionary == null) {
      return false;
    }
    List<dynamic> temp = dictionary!;
    int count = word.length;
    for (final l in word.runes) {
      count--;
      if (temp.length > 1) {
        // the current node has children
        if (temp[1] is int) {
          // is a leaf
          return count == 0;
          //check if last letter of the word
        } else {
          for (int i = 1; i < temp.length; i++) {
            if (temp[i] is int) {
              //is a leaf
              if (decoder.getRunesFrom(temp[i]) == Int8(l)) {
                return count == 0;
                //check if last letter of the word
              }
            } else {
              if (decoder.getRunesFrom(temp[i][0]) == Int8(l)) {
                temp = temp[i][0];
              }
            }
          }
        }
      } else {
        return false; // more letter than node for this word
      }
    }

    return true;
  }
}
