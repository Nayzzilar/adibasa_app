class ChallengeOption {
  //final String id;
  //final String challengeId;
  final String text;
  final bool correct;

  ChallengeOption({
    //required this.id,
    //required this.challengeId,
    required this.text,
    required this.correct,
  });

  factory ChallengeOption.fromJson(Map<String, dynamic> json) =>
      ChallengeOption(
        //id: json['id'],
        //challengeId: json['challengeId'],
        text: json['text'],
        correct: json['correct'],
      );

  Map<String, dynamic> toJson() => {
        //'id': id,
        //'challengeId': challengeId,
        'text': text,
        'correct': correct,
      };
}
