import 'package:flutter/material.dart';
import 'package:adibasa_app/services/dictionary_service.dart';
import 'package:adibasa_app/models/word.dart';
import 'package:adibasa_app/theme/theme.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final List<String> alphabets = List.generate(
    26,
    (index) => String.fromCharCode('A'.codeUnitAt(0) + index),
  );

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
      _wordList = dictionary.listWords;
      // Selalu urutkan _wordList secara ascending (A-Z) saat pertama dimuat
      _wordList.sort(
        (a, b) => a.word.toLowerCase().compareTo(b.word.toLowerCase()),
      );

      setState(() {
        _filteredWords = List.from(
          _wordList,
        ); // _filteredWords mengikuti _wordList yang sudah terurut
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
        // _wordList sudah diurutkan 'asc'
        _filteredWords = List.from(_wordList);
      });
    } else {
      final searchResults = await _dictionaryService.searchWord(query);
      setState(() {
        _filteredWords = searchResults;
        // Selalu urutkan hasil pencarian secara ascending
        _filteredWords.sort(
          (a, b) => a.word.toLowerCase().compareTo(b.word.toLowerCase()),
        );
      });
    }
  }

  // Fungsi untuk scroll ke abjad tertentu
  void _scrollToAlphabet(String alphabet) {
    if (itemScrollController.isAttached && _filteredWords.isNotEmpty) {
      final int indexToScroll = _filteredWords.indexWhere(
        (word) =>
            word.word.isNotEmpty &&
            word.word.toUpperCase().startsWith(alphabet),
      );

      if (indexToScroll != -1) {
        itemScrollController.scrollTo(
          index: indexToScroll,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tidak ada kata yang dimulai dengan "$alphabet"'),
          ),
        );
      }
    }
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
                          hintStyle: Theme.of(
                            context,
                          ).textTheme.headlineSmall!.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
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
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
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
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            )
                            : ScrollablePositionedList.builder(
                              itemScrollController: itemScrollController,
                              itemPositionsListener: itemPositionsListener,
                              itemCount: _filteredWords.length,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemBuilder: (context, index) {
                                final word = _filteredWords[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.outline,
                                        offset: const Offset(0, 2),
                                        blurRadius: 0,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          word.word,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.headlineSmall!.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
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

                  // Sidebar Alphabet Scroller (HANYA TAMPIL JIKA _sortOrder == 'asc' dan ada kata)
                  if (!_isLoading && _filteredWords.isNotEmpty)
                    Container(
                      width: 28,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      alignment: Alignment.center,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: alphabets.length,
                        itemBuilder: (context, index) {
                          final alphabet = alphabets[index];
                          return InkWell(
                            onTap: () {
                              _scrollToAlphabet(alphabet);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 3.0,
                                horizontal: 4.0,
                              ),
                              child: Text(
                                alphabet,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .copyWith(fontSize: 10, fontWeight: FontWeight.w800)
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
