class Level {
  final int level;
  final String name;
  final String description;
  final int stars;
  final bool isLocked;

  Level({
    required this.level,
    required this.name,
    required this.description,
    required this.stars,
    required this.isLocked,
  });

  @override
  String toString() {
    return 'Level $level: $name - $description';
  }
}