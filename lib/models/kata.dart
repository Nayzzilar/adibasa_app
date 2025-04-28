class Kata {
  final String word;
  final String definition;
  final List<String> labels;

  Kata({
    required this.word,
    required this.definition,
    required this.labels,
  });

  factory Kata.fromJson(Map<String, dynamic> json) {
    return Kata(
      word: json['word'] ?? '',
      definition: json['definition'] ?? '',
      labels: List<String>.from(json['labels'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'definition': definition,
      'labels': labels,
    };
  }
}
