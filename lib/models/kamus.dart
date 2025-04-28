import 'kata.dart';

class Kamus {
  final List<Kata> daftarKata;

  Kamus({required this.daftarKata});

  factory Kamus.fromJsonList(List<dynamic> jsonList) {
    return Kamus(
      daftarKata: jsonList.map((json) => Kata.fromJson(json)).toList(),
    );
  }

  List<Map<String, dynamic>> toJsonList() {
    return daftarKata.map((kata) => kata.toJson()).toList();
  }
}
