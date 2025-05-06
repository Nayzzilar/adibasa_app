import 'package:flutter/material.dart';
import 'package:adibasa_app/services/dictionary_service.dart';
import 'package:adibasa_app/models/word.dart';
import 'package:adibasa_app/theme/theme.dart';

void main() {
  runApp(const Kamus());
}

class Kamus extends StatelessWidget {
  const Kamus({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MaterialTheme(const TextTheme()).light(),
      home: const KamusPage(),
    );
  }
}

class KamusPage extends StatefulWidget {
  const KamusPage({super.key});

  @override
  State<KamusPage> createState() => _KamusPageState();
}

class _KamusPageState extends State<KamusPage> {
  final DictionaryService _dictionaryService = DictionaryService();
  final TextEditingController _searchController = TextEditingController();
  List<Word> _wordList = [];
  List<Word> _filteredWords = [];
  bool _isLoading = true;
  String _sortOrder = 'asc'; // 'asc' atau 'desc'

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

  void _toggleSortOrder() {
    setState(() {
      if (_sortOrder == 'asc') {
        _sortOrder = 'desc';
        _filteredWords.sort((a, b) => b.word.compareTo(a.word));
      } else {
        _sortOrder = 'asc';
        _filteredWords.sort((a, b) => a.word.compareTo(b.word));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                'Kamus',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari kata',
                          hintStyle: Theme.of(context).textTheme.headlineSmall!
                                        .copyWith(color: Theme.of(context).colorScheme.outline),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: const Icon(Icons.search),
                        ),
                        onChanged: _searchWords,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _toggleSortOrder,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Sort',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Icon(
                            _sortOrder == 'asc'
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: Color(0xFF6B4C23),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  _isLoading
                      ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF6B4C23),
                        ),
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
                              ], // Tambahkan array untuk BoxShadow
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    word.word,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(fontSize: 16, fontWeight: FontWeight.w800),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    word.definition,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}