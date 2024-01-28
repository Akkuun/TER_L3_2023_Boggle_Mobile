import 'dart:convert';

import 'package:binary/binary.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:flutter/services.dart';

class Dictionary {
  final String path;
  final Decoded decoder;
  late dynamic dictionary; // dictionary[0] = key  dictionary[1] = children

  Dictionary({required this.path, required this.decoder});

  /// The function loads a JSON file from the specified path and decodes it into a dictionary.
  load() {
    rootBundle
        .loadString(path)
        .then((value) => {dictionary = jsonDecode(value)});
  }

  /// The function "unload" sets the variable "dictionary" to null.
  void unload() {
    dictionary = null;
  }

  /// The function "contain" check if a string is in the dictionary
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
      } else {
        return false; // more letter than node for this word
      }
    }

    return decoder.isEndingAWord(temp[0]);
  }

  /// The function "canCreate" check if a string can be completed to create a word in the dictionary
  bool canCreate(String word) {
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

        bool update = false;
        for (int i = 0; i < children.length; i++) {
          if (children[i].runtimeType == int) {
            //is a leaf
            if (decoder.getRunesFrom(children[i]) == Int8(l)) {
              return count == 0;
              //check if last letter of the word
            }
          } else {
            if (decoder.getRunesFrom(children[i][0]) == Int8(l)) {
              temp = children[i];
              update = true;
              break; //child found
            }
          }
        }
        if (!update) {
          // check if we found a child that match the letter (l)
          return false;
        }
      } else {
        return false; // more letter than node for this word
      }
    }

    return true;
  }
}
