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
    return snapshot.docs.map((doc) {
      return Lesson.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }
}
