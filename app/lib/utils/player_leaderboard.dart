class PlayerStats {
  String name;
  int score;
  int? rank;
  String uid;

  PlayerStats({required this.name, required this.score, required this.uid, this.rank});
}

class PlayerLeaderboard {
  List<PlayerStats>? players;

  PlayerLeaderboard([this.players]);

  void init() {
    players = [];
  }

  void addPlayer(PlayerStats playerStats) {
    players?.add(playerStats);
  }

  void computeRank() {
    players?.sort((a, b) => b.score.compareTo(a.score));
    for (int i = 0; i < players!.length; i++) {
      players![i].rank = i + 1;
    }
  }

  PlayerStats getPlayer(String uid) {
    return players!.firstWhere((element) => element.uid == uid);
  }

  List<PlayerStats> firstn(int n) {
    if (players!.length < n) {
      return players!;
    }
    return players!.sublist(0, n);
  }
}