enum PageName {
  home(n: 0),
  game(n: 1);

  final int n;
  const PageName({required this.n});

  int get() => n;
}
