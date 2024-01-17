enum PageName {
  home(n: 0),
  game(n: 1),
  rules(n:2);

  final int n;
  const PageName({required this.n});

  int id() => n;
}
