import 'package:flutter/material.dart';
import 'package:adibasa_app/services/dictionary_service.dart';
import 'package:adibasa_app/models/word.dart';

class NormalDictionary extends StatefulWidget {
  const NormalDictionary({super.key});

  @override
  State<NormalDictionary> createState() => _NormalDictionaryState();
}

class _NormalDictionaryState extends State<NormalDictionary> {
  final DictionaryService _dictionaryService = DictionaryService();
  final TextEditingController _searchController = TextEditingController();
  List<Word> _wordList = [];
  List<Word> _filteredWords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDictionary();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDictionary() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dictionary = await _dictionaryService.loadDictionaryFromAssets();
      setState(() {
        _wordList = dictionary.listWords;
        _filteredWords = _wordList;
        _isLoading = false;
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
        _filteredWords = _wordList;
      });
    } else {
      final searchResults = await _dictionaryService.searchWord(query);
      setState(() {
        _filteredWords = searchResults;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
          child: CircularProgressIndicator(color: Color(0xFF6B4C23)),
        )
        : _filteredWords.isEmpty
        ? Center(
          child: Text(
            'Tidak ada kata yang ditemukan',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _filteredWords.length,
          itemBuilder: (context, index) {
            final word = _filteredWords[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.outline,
                    offset: const Offset(0, 2),
                    blurRadius: 0,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      word.word,
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      word.definition,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall!.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        );
  }
}
