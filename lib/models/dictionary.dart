import 'word.dart';

class Dictionary {
  final List<Word> listWords;

  Dictionary({required this.listWords});

  factory Dictionary.fromJsonList(List<dynamic> jsonList) {
    return Dictionary(
      listWords: jsonList.map((json) => Word.fromJson(json)).toList(),
    );
  }

  List<Map<String, dynamic>> toJsonList() {
    return listWords.map((word) => word.toJson()).toList();
  }
}
