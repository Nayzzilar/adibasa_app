import 'dart:async';
//import 'dart:convert';

import 'package:adibasa_app/models/lesson_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionService {
  final CollectionReference _questionCollection = FirebaseFirestore.instance
      .collection('lessons');

  // Buat cache global di service-mu
  List<Lesson> _lessonCache = [];

  // Function untuk fetch semua lessons secara dinamis dan urut
  Future<List<Lesson>> getAllQuestionsSequential() async {
    // Kalau sudah ada di cache local service, pakai langsung
    if (_lessonCache.isNotEmpty) {
      return _lessonCache;
    }

    try {
      // Fetch dari cache atau server, Firebase yang pintar pilih
      final querySnapshot = await _questionCollection.get(
        const GetOptions(source: Source.cache), // 📦 Pakai cache DULU
      );

      if (querySnapshot.docs.isEmpty) {
        // Kalau cache kosong (misal baru install app), fetch dari server
        final serverSnapshot = await _questionCollection.get(
          const GetOptions(
            source: Source.serverAndCache,
          ), // 🌎 Fetch dari server
        );

        return _processLessons(serverSnapshot);
      }

      return _processLessons(querySnapshot);
    } catch (e) {
      // Kalau error, fallback fetch dari server
      final serverSnapshot = await _questionCollection.get(
        const GetOptions(source: Source.serverAndCache),
      );
      return _processLessons(serverSnapshot);
    }
  }

  List<Lesson> _processLessons(QuerySnapshot snapshot) {
    final docs = snapshot.docs;
    docs.sort((a, b) => a.id.compareTo(b.id));

    List<Lesson> lessons = [];

    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final lesson = Lesson.fromJson(data);
      lessons.add(lesson);
    }

    // ini untuk testing data debug. jadi kalo misal ada data baru nanti ngecek datanya masuk apa gk lewat code ini
    // for (final lesson in lessons) {
    //   print('---');
    //   print('Lesson ID: ${lesson.id}');
    //   print('Lesson Title: ${lesson.title}');
    //   print('Jumlah Soal: ${lesson.challenges?.length ?? 0}');

    //   if (lesson.challenges != null && lesson.challenges!.isNotEmpty) {
    //     for (final challenge in lesson.challenges!) {
    //       print('  - Question: ${challenge.question}');
    //       print('    Instruction: ${challenge.instruction}');
    //       print('    Options:');
    //       if (challenge.options != null && challenge.options!.isNotEmpty) {
    //         for (final option in challenge.options!) {
    //           print('      * ${option.text} (Correct: ${option.correct})');
    //         }
    //       }
    //     }
    //   }
    //   print('---');
    // }

    _lessonCache = lessons; // Simpan di cache lokal service

    return lessons;
  }

  // Kalau mau clear cache manual (opsional aja kalau mau reset data)
  void clearLessonCache() {
    _lessonCache.clear();
  }
}

// final amplop = await _questionCollection.get();  // querySnapshot
// final kertas2 = amplop.docs;                     // List<DocumentSnapshot>
// final isi = kertas2.first.data();                // Map<String, dynamic>
