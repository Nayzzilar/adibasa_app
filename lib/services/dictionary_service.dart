import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/dictionary.dart';
import '../models/word.dart';

class DictionaryService {
  // Fungsi utama buat load JSON dari assets
  Future<Dictionary> loadDictionaryFromAssets() async {
    final String response = await rootBundle.loadString('data/kamus_jawa_indonesia_cleaned.json');
    final List<dynamic> data = json.decode(response);

    return Dictionary.fromJsonList(data);
  }

  // Optional: fungsi untuk cari kata langsung di sini
  Future<List<Word>> searchWord(String query) async {
    final dictionary = await loadDictionaryFromAssets();
    return dictionary.listWords.where((word) {
      return word.word.toLowerCase().contains(query.toLowerCase()) ||
          word.definition.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
