import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:adibasa_app/services/kamus_service.dart';
import 'package:adibasa_app/models/kata.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Supaya bisa load asset

  group('KamusService Test', () {
    test('Load kamus from assets', () async {
      final kamusService = KamusService();
      final kamus = await kamusService.loadKamusFromAssets();

      // Test kamus tidak kosong
      expect(kamus.daftarKata.isNotEmpty, true);

      // Print contoh output
      Kata first = kamus.daftarKata.first;
      print('Word: ${first.word}');
      print('Definition: ${first.definition}');
      print('Labels: ${first.labels}');
    });
  });
}
