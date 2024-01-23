import 'dart:convert';

import 'package:binary/binary.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:flutter/services.dart';

class Dictionary {
  final String path;
  final Decoded decoder;
  late dynamic dictionary;

  Dictionary({required this.path, required this.decoder});

  Future load() async {
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
    dynamic temp = dictionary!;
    int count = word.length;
    for (final l in word.runes) {
      count--;
      if (temp.length > 1) {
        dynamic children = temp[1];
        // the current node has children
        if (children.runtimeType == int) {
          // is a leaf
          return count == 0 && decoder.isEndingAWord(temp[1]);
          //check if last letter of the word & if is completing a word
        } else {
          bool update = false;
          for (int i = 0; i < children.length; i++) {
            if (children[i].runtimeType == int) {
              //is a leaf
              if (decoder.getRunesFrom(children[i]) == Int8(l)) {
                return count == 0 && decoder.isEndingAWord(temp[1][i]);
                //check if last letter of the word & if is completing a word
              }
            } else {
              if (decoder.getRunesFrom(children[i][0]) == Int8(l)) {
                temp = children[i];
                update = true;
                break;
              }
            }
          }
          if (!update) {
            return false;
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
        if (temp[1].runtimeType == int) {
          // is a leaf
          return count == 0;
          //check if last letter of the word
        } else {
          for (int i = 1; i < temp.length; i++) {
            if (temp[i].runtimeType == int) {
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
