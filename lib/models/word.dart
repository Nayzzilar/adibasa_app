class Word {
  final String word;
  final String definition;
  final List<String> labels;

  Word({
    required this.word,
    required this.definition,
    required this.labels,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
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
