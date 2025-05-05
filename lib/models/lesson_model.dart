import 'package:adibasa_app/models/challenge_model.dart';

class Lesson {
  final String id;
  final String title;
  //final String unitId;
  final int order;
  final List<Challenge>? challenges;

  Lesson({
    required this.id,
    required this.title,
    //required this.unitId,
    required this.order,
    this.challenges,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json['id']?? "",
        title: json['title'],
        //unitId: json['unitId'],
        order: json['order'] ?? 0,
        challenges: (json['challenges'] as List?)
            ?.whereType<Map<String, dynamic>>().map((e) => Challenge.fromJson(e))
            .toList() ?? [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        //'unitId': unitId,
        'order': order,
        if (challenges != null)
          'challenges': challenges!.map((c) => c.toJson()).toList(),
      };
}
