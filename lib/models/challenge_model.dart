import "package:adibasa_app/models/challenge_option_model.dart";

enum ChallengeType { multipleChoice, ordering }

ChallengeType challengeTypeFromString(String? value) {
  switch (value) {
    case 'multiple_choice':
      return ChallengeType.multipleChoice;
    case 'ordering':
      return ChallengeType.ordering;
    default:
      return ChallengeType.multipleChoice;
  }
}

String challengeTypeToString(ChallengeType type) {
  switch (type) {
    case ChallengeType.multipleChoice:
      return 'multiple_choice';
    case ChallengeType.ordering:
      return 'ordering';
  }
}

class Challenge {
  final String question;
  final int order;
  final String instruction;
  final ChallengeType challengeType;
  final List<ChallengeOption>? options;

  Challenge({
    required this.question,
    required this.order,
    required this.instruction,
    required this.challengeType,
    this.options,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
    question: json['question'] ?? "",
    order: json['order'] ?? 0,
    instruction: json['instruction'] ?? "",
    challengeType: challengeTypeFromString(json['challenge_type']),
    options:
        (json['options'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .map((e) => ChallengeOption.fromJson(e))
            .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    'question': question,
    'order': order,
    'instruction': instruction,
    'challenge_type': challengeTypeToString(challengeType),
    if (options != null) 'options': options!.map((o) => o.toJson()).toList(),
  };
}
