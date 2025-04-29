import 'package:flutter/material.dart';
import 'package:adibasa_app/navigation/buttom_navbar.dart';
import 'package:adibasa_app/services/dictionary_service.dart';
import 'package:adibasa_app/models/word.dart';

void main() {
  runApp(const Kamus());
}

class Kamus extends StatelessWidget {
  const Kamus({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Serif',
        primaryColor: const Color(0xFFE4CBA8),
        scaffoldBackgroundColor: const Color(0xFFE4CBA8),
      ),
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
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFCBB28E),
                    width: 1,
                  ),
                ),
              ),
              child: const Text(
                'Kamus',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B4C23),
                ),
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari kata',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
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
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          Text(
                            'Sort',
                            style: TextStyle(
                              color: Color(0xFF6B4C23),
                              fontWeight: FontWeight.bold,
                            ),
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
              child: _isLoading
                  ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF6B4C23),
                ),
              )
                  : _filteredWords.isEmpty
                  ? const Center(
                child: Text(
                  'Tidak ada kata yang ditemukan',
                  style: TextStyle(
                    color: Color(0xFF6B4C23),
                    fontSize: 16,
                  ),
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
                      color: const Color(0xFFEFDCC4),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFDBC59F),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            word.word,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6B4C23),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            word.definition,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B4C23),
                            ),
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
      bottomNavigationBar: BottomNavbar(),
    );
  }
}