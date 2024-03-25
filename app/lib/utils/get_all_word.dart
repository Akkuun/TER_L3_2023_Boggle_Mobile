import 'dart:collection';
import 'dart:isolate';

Future<List<String>> getAllWords(String grid, dynamic dico) async {
  return Isolate.run(() => _getAllWords(grid, dico));
}

List<String> _getAllWords(String grid, dynamic dico) {
  if (dico.runtimeType != List) {
    return List.empty();
  }

  if (dico.isEmpty) {
    return List.empty();
  }

  HashMap<String, bool> resMap = HashMap<String, bool>();

  ReceivePort receivePort = ReceivePort();

  Isolate.spawn(_startAtAllPoint, [grid, dico, receivePort.sendPort]);

  receivePort.listen((data) {
    if (data is String) {
      resMap[data] = true;
    }
  });

  return resMap.keys.toList();
}

void _startAtAllPoint(List<dynamic> args) {
  _start(args[0], args[1], args[2]);
}

void _start(String grid, dynamic dico, SendPort sp) {
  for (var i in {0, 1, 2, 3}) {
    for (var j in {0, 1, 2, 3}) {
      Isolate.spawn(_initPoint, [grid, i, j, dico, grid[i * 4 + j], sp]);
    }
  }
}

void _initPoint(List<dynamic> args) {
  _init(args[0], args[1], args[2], args[3], args[4], args[5]);
}

void _init(String grid, int i, int j, dynamic dico, String point, SendPort sp) {
  var used = List.generate(4, (index) => List.generate(4, (index) => false));
  used[i][j] = true;
  var children = dico[1];
  var n = _getChild(children, point);
  if (n != null) {
    //if no children for this letter
    return;
  }
  if (n is List) {
    _appendFromPoint(sp, grid, point, i, j, used, n);
  }
}

const move = {-1, 0, 1};

void _appendFromPoint(SendPort sp, String grid, String word, int i, int j,
    List<List<bool>> used, dynamic node) {
  if (node.runtimeType != List) {
    return;
  }

  var val = node[0];

  if (val.runtimeType != int) {
    return;
  }

  if ((val & 0x100) > 0) {
    sp.send(word);
  }

  if ((node as List).length < 2) {
    return;
  }

  int ix, jy, index;

  List<dynamic> children = node[1];

  for (var a in move) {
    for (var b in move) {
      ix = a + i;
      jy = b + j;
      index = ix * 4 + jy;
      if (ix < 0 || jy < 0 || ix > 3 || jy > 3) {
        //out of range
        continue;
      }
      if (used[ix][jy]) {
        // can't use the same letter twice
        continue;
      }

      var newLetter = grid[index];

      var n = _getChild(children, newLetter);
      if (n == null) {
        continue;
      }

      used[ix][jy] = true;
      if (n is int) {
        _appendFromPoint(sp, grid, word + newLetter, ix, jy, used, {n});
      } else {
        _appendFromPoint(sp, grid, word + newLetter, ix, jy, used, n);
      }
      used[ix][jy] = false;
    }
  }
}

dynamic _getChild(dynamic children, String newLetter) {
  for (var n in children) {
    if (n.runtimeType != List &&
        (n & newLetter.codeUnitAt(0) == newLetter.codeUnitAt(0))) {
      // if no children -> leaf
      return n;
    }
    if (n.runtimeType != List) {
      continue;
    }

    if ((n[0] & newLetter.codeUnitAt(0)) == newLetter.codeUnitAt(0)) {
      //with children
      return n;
    }
  }
  return null;
}
