import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adibasa_app/services/dictionary_service.dart';
import 'package:adibasa_app/models/word.dart';
import 'package:adibasa_app/models/user_data_model.dart';
import 'package:adibasa_app/providers/user_data_provider.dart';

class SeenWordsDictionary extends ConsumerStatefulWidget {
  final Function(List<Word>) onWordsLoaded;
  final String searchQuery;

  const SeenWordsDictionary({
    super.key,
    required this.onWordsLoaded,
    required this.searchQuery,
  });

  @override
  ConsumerState<SeenWordsDictionary> createState() =>
      _SeenWordsDictionaryState();
}

class _SeenWordsDictionaryState extends ConsumerState<SeenWordsDictionary> {
  final DictionaryService _dictionaryService = DictionaryService();
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
  void didUpdateWidget(SeenWordsDictionary oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _searchWords(widget.searchQuery);
    }
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

    final Map<String, Word> dictionaryMap = {};
    for (Word word in _allWords) {
      dictionaryMap[word.word.toLowerCase().trim()] = word;
      dictionaryMap[word.word.trim()] = word;
    }

    setState(() {
      _seenWords = [];

      for (String seenWord in seenWordsSet) {
        String normalizedSeenWord = seenWord.toLowerCase().trim();

        Word? foundWord =
            dictionaryMap[normalizedSeenWord] ??
            dictionaryMap[seenWord.trim()] ??
            dictionaryMap[seenWord];

        if (foundWord != null) {
          _seenWords.add(foundWord);
        } else {
          _seenWords.add(
            Word(word: seenWord, definition: "", labels: [seenWord]),
          );
        }
      }

      // Sort alphabetically
      _seenWords.sort(
        (a, b) => a.word.toLowerCase().compareTo(b.word.toLowerCase()),
      );
      _filteredWords = List.from(_seenWords);
      _isLoading = false;

      // Notify parent with the loaded words
      widget.onWordsLoaded(_filteredWords);
    });
  }

  void _searchWords(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredWords = List.from(_seenWords);
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

      // Notify parent with filtered words
      widget.onWordsLoaded(_filteredWords);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataProvider);

    // Auto refresh when seenWords changes
    ref.listen<UserData>(userDataProvider, (previous, next) {
      if (previous?.seenWords != next.seenWords) {
        _filterSeenWords();
      }
    });

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF6B4C23)),
      );
    }

    if (userData.seenWords.isEmpty) {
      return Center(
        child: Text(
          'Belum ada kata yang dijumpai\nMulai belajar untuk mengumpulkan kata!',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
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

    // Return the filtered words list without scrollable
    return Container(); // This will be handled by parent
  }
}
