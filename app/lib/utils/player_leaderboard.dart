class PlayerStats {
  String name;
  int score;
  String uid;

  PlayerStats({required this.name, required this.score, required this.uid});
}

class PlayerLeaderboard {
  List<PlayerStats> players = [];

  PlayerLeaderboard();

  void addPlayer(PlayerStats playerStats) {
    if (players.any((element) => element.uid == playerStats.uid)) {
      return;
    }
    players.add(playerStats);
  }

  void computeRank() {
    players.sort((a, b) => b.score.compareTo(a.score));
  }

  void remove(List<dynamic> p) {
    players.removeWhere((element) => !p.contains(element.uid));
  }

  PlayerStats? getPlayer(String uid) {
    return players.firstWhere((element) => element.uid == uid);
  }

  void updatePlayer(String uid, int score) {
    var player = players.firstWhere((element) => element.uid == uid);
    player.score = score;
  }

  int getRank(String uid) {
    return players.indexWhere((element) => element.uid == uid) + 1;
  }

  List<PlayerStats> firstn(int n) {
    if (players.length < n) {
      return players;
    }
    return players.sublist(0, n);
  }
}
