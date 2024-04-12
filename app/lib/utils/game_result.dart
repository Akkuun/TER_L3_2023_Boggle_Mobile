class GameResult {
  final int score;
  final List<int> words;
  String uid = 'guest'; // 'guest' is the default value for 'uid
  final String grid;

  GameResult({
    required this.score,
    required this.grid,
    required this.words,
  });

  set uID(String uid) {
    this.uid = uid;
  }

  Map<String, dynamic> toJsonLocal() {
    return {
      'uid': uid,
      'score': score,
      'grid': grid,
      'words': words,
    };
  }

  Map<String, dynamic> toJsonOnline() {
    return {
      'score': score,
      'grid': grid,
      'words': words,
    };
  }

  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
      score: json['score'],
      grid: json['grid'],
      words: json['words'].cast<String>(),
    );
  }
}
