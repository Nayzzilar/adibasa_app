import 'package:flutter_test/flutter_test.dart';
import 'package:adibasa_app/services/dictionary_service.dart';
import 'package:adibasa_app/models/word.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Supaya bisa load asset

  group('DictionaryService Test', () {
    test('Load dictionary from assets', () async {
      final dictionaryService = DictionaryService();
      final dictionary = await dictionaryService.loadDictionaryFromAssets();

      // Test dictionary tidak kosong
      expect(dictionary.listWords.isNotEmpty, true);

      // Print contoh output
      Word first = dictionary.listWords.first;
      print('Word: ${first.word}');
      print('Definition: ${first.definition}');
      print('Labels: ${first.labels}');
    });
  });
}
