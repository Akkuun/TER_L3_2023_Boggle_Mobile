import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:bouggr/global.dart';
import 'package:bouggr/utils/decode.dart';
import 'package:bouggr/utils/dico.dart';

Future<List<String>> getAllWords(List<String> grid, dynamic dico) async {
  return _getAllWords(grid, dico);
}

Future<List<String>> _getAllWords(List<String> grid, dynamic dico) async {
  HashMap<String, bool> resMap = HashMap<String, bool>();

  if (dico.runtimeType != List) {
    return List.empty();
  }

  if (dico.isEmpty) {
    return List.empty();
  }

  _start(grid, dico, resMap);
  var res = resMap.keys.toList();
  res.sort((a, b) => -a.length.compareTo(b.length));

  return res;
}

void _start(List<String> grid, dynamic dico, HashMap<String, bool> rp) {
  for (var i in const {0, 1, 2, 3}) {
    for (var j in const {0, 1, 2, 3}) {
      _init(grid, i, j, dico, grid[i * 4 + j], rp);
    }
  }
}

void _init(List<String> grid, int i, int j, dynamic dico, String point,
    HashMap<String, bool> sp) {
  var used = List.generate(16, (index) => false);
  used[i * 4 + j] = true;
  List<dynamic> children = dico[1];
  var n = _getChild(children, point);
  if (n != null) {
    _appendFromPoint2(
        sp, grid, point, i, j, used, Globals.selectDictionary(LangCode.FR));
  }
}

const move = {-1, 0, 1};

Future<void> _appendFromPoint2(HashMap<String, bool> sp, List<String> grid,
    String word, int i, int j, List<bool> used, Dictionary dico) async {
  if (dico.contain(word)) {
    sp[word] = true;
  }

  if (!dico.canCreate(word)) {
    return;
  }

  int ix, jy, index;

  for (var a in move) {
    for (var b in move) {
      ix = a + i;
      jy = b + j;

      if (ix < 0 || jy < 0 || ix > 3 || jy > 3) {
        //out of range
        continue;
      }
      index = ix * 4 + jy;
      if (used[index]) {
        // can't use the same letter twice
        continue;
      }

      var newLetter = grid[index];

      used[index] = true;
      _appendFromPoint2(sp, grid, word + newLetter, ix, jy, used, dico);
      used[index] = false;
    }
  }
}

Future<void> _appendFromPoint(HashMap<String, bool> sp, List<String> grid,
    String word, int i, int j, List<bool> used, dynamic node) async {
  var val = node.runtimeType == (List<dynamic>) ? node[0] : node;

  if ((val & (1 << 8)) > 0) {
    sp[word] = true;
    if (val.runtimeType == int) return;
  }

  int ix, jy, index;

  List<dynamic> children = node[1];

  for (var a in move) {
    for (var b in move) {
      ix = a + i;
      jy = b + j;

      if (ix < 0 || jy < 0 || ix > 3 || jy > 3) {
        //out of range
        continue;
      }
      index = ix * 4 + jy;
      if (used[index]) {
        // can't use the same letter twice
        continue;
      }

      var newLetter = grid[index];

      var n = _getChild(children, newLetter);
      if (n == null) {
        //no child
        continue;
      }

      used[index] = true;
      _appendFromPoint(sp, grid, word + newLetter, ix, jy, used, n);
      used[index] = false;
    }
  }
}

dynamic _getChild(List<dynamic> children, String newLetter) {
  var rune = utf8.encode(newLetter)[0];

  for (var n in children) {
    if ((n.runtimeType != List<dynamic>) && ((n & rune) == rune)) {
      // if no children -> leaf
      return n;
    }
    if (n.runtimeType != List<dynamic>) {
      continue;
    }

    if (((n[0] as int) & rune) == rune) {
      //with children
      return n;
    }
  }
  return null;
}
