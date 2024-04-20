import 'dart:async';
import 'dart:collection';
import 'package:bouggr/utils/dico.dart';
import 'package:native_ffi/native_ffi.dart';

Future<List<Word>> getAllWords2(List<String> grid, Dictionary dico) async {
  HashMap<String, Word> resMap = HashMap<String, Word>();

  while (dico.dictionary == null) {
    await dico.ayncLoad();
  }

  _start2(grid, dico, resMap);

  var res = resMap.values.toList();
  res.sort((a, b) => b.txt.length - a.txt.length);
  return res;
}

void _start2(List<String> grid, dynamic dico, HashMap<String, Word> rp) {
  for (var i in const {0, 1, 2, 3}) {
    for (var j in const {0, 1, 2, 3}) {
      _init2(grid, i, j, dico, grid[i * 4 + j], rp);
    }
  }
}

void _init2(List<String> grid, int i, int j, Dictionary dico, String point,
    HashMap<String, Word> sp) {
  var used = List.generate(16, (index) => false);
  used[i * 4 + j] = true;

  _appendFromPoint2(sp, grid, Word(point, [Coord(i, j)]), i, j, used,
      _getChild(dico.dictionary[1], point));
}

const move = {-1, 0, 1};

Future<void> _appendFromPoint2(HashMap<String, Word> sp, List<String> grid,
    Word word, int i, int j, List<bool> used, dynamic node) async {
  var val = node.runtimeType == (List<dynamic>) ? node[0] : node;

  if (endOfWorld(val)) {
    sp[word.txt] = word;
    if (node.runtimeType == int) return;
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

      _appendFromPoint2(
          sp, grid, word.append(newLetter, Coord(ix, jy)), ix, jy, used, n);
      used[index] = false;
    }
  }
}

dynamic _getChild(List<dynamic> children, String newLetter) {
  for (var n in children) {
    if ((n.runtimeType != List<dynamic>) && (isSameKey(newLetter, n))) {
      // if no children -> leaf
      return n;
    }
    if (n.runtimeType != List<dynamic>) {
      continue;
    }

    if (isSameKey(newLetter, n[0])) {
      //with children
      return n;
    }
  }
  return null;
}

class Coord {
  int x;
  int y;

  Coord(this.x, this.y);
}

class Word {
  String txt;
  List<Coord> coords;
  Word(this.txt, this.coords);

  Word append(String letter, Coord coord) {
    return Word(txt + letter, List.from(coords)..add(coord));
  }

  void removeLast() {
    txt = txt.substring(0, txt.length - 1);
    coords.removeLast();
  }

  bool isAtCoord(int index) {
    return coords.any((element) => element.x * 4 + element.y == index);
  }

  int indexOfCoords(int index) {
    return coords.indexWhere((element) => element.x * 4 + element.y == index);
  }

  bool isFirstChild(int index) {
    return coords.first.x * 4 + coords.first.y == index;
  }

  @override
  String toString() {
    return "$txt : ${coords.map((e) => "(${e.x},${e.y})").join(', ')}";
  }

  String toCoordString() {
    return coords.map((e) => "(${e.x},${e.y})").join(', ');
  }
}
