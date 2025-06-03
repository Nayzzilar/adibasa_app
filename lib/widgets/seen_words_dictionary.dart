import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adibasa_app/services/dictionary_service.dart';
import 'package:adibasa_app/models/word.dart';
import 'package:adibasa_app/models/user_data_model.dart';
import 'package:adibasa_app/providers/user_data_provider.dart';

class SeenWordsDictionary extends ConsumerStatefulWidget {
  const SeenWordsDictionary({super.key});

  @override
  ConsumerState<SeenWordsDictionary> createState() =>
      _SeenWordsDictionaryState();
}

class _SeenWordsDictionaryState extends ConsumerState<SeenWordsDictionary> {
  final DictionaryService _dictionaryService = DictionaryService();
  final TextEditingController _searchController = TextEditingController();
  List<Word> _allWords = [];
  List<Word> _seenWords = [];
  List<Word> _filteredWords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSeenWordsDictionary();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSeenWordsDictionary() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dictionary = await _dictionaryService.loadDictionaryFromAssets();
      _allWords = dictionary.listWords;
      _filterSeenWords();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading dictionary: $e');
    }
  }

  void _filterSeenWords() {
    final userData = ref.read(userDataProvider);
    final seenWordsSet = userData.seenWords;

    // Create a map for faster lookup - normalize dictionary words
    final Map<String, Word> dictionaryMap = {};
    for (Word word in _allWords) {
      // Store both original and lowercase versions
      dictionaryMap[word.word.toLowerCase().trim()] = word;
      dictionaryMap[word.word.trim()] = word;
    }

    setState(() {
      _seenWords = [];
      List<String> notFoundWords = [];

      for (String seenWord in seenWordsSet) {
        String normalizedSeenWord = seenWord.toLowerCase().trim();

        // Try multiple matching strategies
        Word? foundWord =
            dictionaryMap[normalizedSeenWord] ??
            dictionaryMap[seenWord.trim()] ??
            dictionaryMap[seenWord];

        if (foundWord != null) {
          _seenWords.add(foundWord);
        } else {
          // FIXED: Create a dummy Word object with proper labels parameter
          _seenWords.add(
            Word(
              word: seenWord,
              definition: "",
              labels: [
                seenWord,
              ], // FIXED: Pass as List<String> instead of String
            ),
          );
          notFoundWords.add(seenWord);
        }
      }

      _filteredWords = List.from(_seenWords); // FIXED: Create a proper copy

      _isLoading = false;
    });
  }

  void _searchWords(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredWords = List.from(_seenWords); // FIXED: Create proper copy
      } else {
        _filteredWords =
            _seenWords
                .where(
                  (word) =>
                      word.word.toLowerCase().contains(query.toLowerCase()) ||
                      word.definition.toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                )
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataProvider);

    // Auto refresh ketika seenWords berubah
    ref.listen<UserData>(userDataProvider, (previous, next) {
      if (previous?.seenWords != next.seenWords) {
        _filterSeenWords();
      }
    });

    return Column(
      children: [
        // Search bar (hanya tampil kalau ada kata)
        if (userData.seenWords.isNotEmpty) const SizedBox(height: 16),

        // Content area
        Expanded(
          child:
              _isLoading
                  ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF6B4C23)),
                  )
                  : userData.seenWords.isEmpty
                  ? Center(
                    child: Text(
                      'Belum ada kata yang dijumpai\nMulai belajar untuk mengumpulkan kata!',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
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
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              const SizedBox(height: 4),
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
    );
  }
}
