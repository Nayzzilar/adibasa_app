import 'package:adibasa_app/models/challenge_model.dart';
import 'package:adibasa_app/models/lesson_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionService {
  static final QuestionService _instance = QuestionService._internal();
  factory QuestionService() => _instance;
  QuestionService._internal();

  final CollectionReference _questionCollection = FirebaseFirestore.instance
      .collection('lessons');

  Future<List<Lesson>> getAllQuestions() async {
    try {
      final snapshot = await _questionCollection
          .orderBy('order')
          .get(const GetOptions(source: Source.serverAndCache));
      return _processLessons(snapshot);
    } catch (e) {
      throw Exception("Failed to fetch lessons: $e");
    }
  }

  List<Lesson> _processLessons(QuerySnapshot snapshot) {
    final lessons =
        snapshot.docs
            .map((doc) => Lesson.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

    const int targetCount = 10;

    for (var i = 1; i < lessons.length; i++) {
      var current = lessons[i];
      final prev = lessons[i - 1];

      final currList = current.challenges ?? <Challenge>[];
      final prevList = prev.challenges ?? <Challenge>[];

      final deficit = targetCount - currList.length;
      if (deficit > 0) {
        final filler = prevList.take(deficit);
        currList.addAll(filler);
      }

      current.challenges = currList;
    }

    return lessons;
  }
}
