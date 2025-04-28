Duration getLevelDuration(DateTime start, DateTime end) {
  return end.difference(start);
}

int calculateStar(Duration duration) {
  if (duration.inSeconds <= 60) {
    return 3;
  } else if (duration.inSeconds <= 120) {
    return 2;
  } else {
    return 1;
  }
} 