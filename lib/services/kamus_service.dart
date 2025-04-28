import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/kamus.dart';
import '../models/kata.dart';

class KamusService {
  // Fungsi utama buat load JSON dari assets
  Future<Kamus> loadKamusFromAssets() async {
    final String response = await rootBundle.loadString('data/kamus_jawa_indonesia.json');
    final List<dynamic> data = json.decode(response);

    return Kamus.fromJsonList(data);
  }

  // Optional: fungsi untuk cari kata langsung di sini
  Future<List<Kata>> searchKata(String query) async {
    final kamus = await loadKamusFromAssets();
    return kamus.daftarKata.where((kata) {
      return kata.word.toLowerCase().contains(query.toLowerCase()) ||
          kata.definition.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
