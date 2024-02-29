class GameResult {
  final String playerName;
  final int score;

  GameResult({
    required this.playerName,
    required this.score,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerName': playerName,
      'score': score,
    };
  }

  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
      playerName: json['playerName'],
      score: json['score'],
    );
  }
}
