import 'package:adibasa_app/models/lesson_model.dart';
import 'package:adibasa_app/services/question_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final lessonsProvider = FutureProvider<List<Lesson>>((ref) async {
  return QuestionService().getAllQuestions();
});
