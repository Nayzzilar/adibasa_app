import 'package:flutter/material.dart';
import 'package:adibasa_app/services/dictionary_service.dart';
import 'package:adibasa_app/models/word.dart';

class NormalDictionary extends StatefulWidget {
  final Function(List<Word>) onWordsLoaded;
  final String searchQuery;

  const NormalDictionary({
    super.key,
    required this.onWordsLoaded,
    required this.searchQuery,
  });

  @override
  State<NormalDictionary> createState() => _NormalDictionaryState();
}

class _NormalDictionaryState extends State<NormalDictionary> {
  final DictionaryService _dictionaryService = DictionaryService();
  List<Word> _wordList = [];
  List<Word> _filteredWords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDictionary();
  }

  @override
  void didUpdateWidget(NormalDictionary oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _searchWords(widget.searchQuery);
    }
  }

  Future<void> _loadDictionary() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dictionary = await _dictionaryService.loadDictionaryFromAssets();
      setState(() {
        _wordList = dictionary.listWords;
        // Sort alphabetically
        _wordList.sort(
          (a, b) => a.word.toLowerCase().compareTo(b.word.toLowerCase()),
        );
        _filteredWords = List.from(_wordList);
        _isLoading = false;

        // Notify parent with loaded words
        widget.onWordsLoaded(_filteredWords);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading dictionary: $e');
    }
  }

  void _searchWords(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredWords = List.from(_wordList);
        widget.onWordsLoaded(_filteredWords);
      });
    } else {
      final searchResults = await _dictionaryService.searchWord(query);
      setState(() {
        _filteredWords = searchResults;
        _filteredWords.sort(
          (a, b) => a.word.toLowerCase().compareTo(b.word.toLowerCase()),
        );
        widget.onWordsLoaded(_filteredWords);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF6B4C23)),
      );
    }

    if (_filteredWords.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada kata yang ditemukan',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      );
    }

    // Return empty container, actual list will be handled by parent
    return Container();
  }
}
