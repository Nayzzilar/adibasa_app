import "package:adibasa_app/models/challenge_option_model.dart";

class Challenge {
  //final String id;
  //final String lessonId;
  final String question;
  final int order;
  final String instruction;
  final List<ChallengeOption>? options;

  Challenge({
    //required this.id,
    //required this.lessonId,
    required this.question,
    required this.order,
    required this.instruction,
    this.options,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
        //id: json['id'],
        //lessonId: json['lessonId'],
        question: json['question'] ?? "",
        order: json['order'] ?? 0,
        instruction: json['instruction'] ?? "",
        options: (json['options'] as List?)
            ?.whereType<Map<String, dynamic>>().map((e) => ChallengeOption.fromJson(e)).toList() ?? [],
      );

  Map<String, dynamic> toJson() => {
        //'id': id,
        //'lessonId': lessonId,
        'question': question,
        'order': order,
        if (options != null)
          'options': options!.map((o) => o.toJson()).toList(),
      };
}
