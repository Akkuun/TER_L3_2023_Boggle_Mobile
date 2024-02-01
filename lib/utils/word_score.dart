int wordScore(String word) {
  int wordLength = word.length;

  if (wordLength < 3) {
    return 0;
  }

  switch (wordLength) {
    case 3:
      return 1;
    case 4:
      return 1;
    case 5:
      return 2;
    case 6:
      return 3;
    case 7:
      return 5;
    default:
      return 11;
  }
}
