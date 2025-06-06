import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adibasa_app/models/word.dart';
import 'package:adibasa_app/theme/theme.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../widgets/normal_dictionary.dart';
import '../widgets/seen_words_dictionary.dart';
import 'dart:async';

void main() {
  runApp(const ProviderScope(child: Kamus()));
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

class _KamusPageState extends State<KamusPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  List<Word> _currentWords = [];
  String _currentSearchQuery = '';
  bool _isScrolling = false;
  Timer? _searchDebounce;

  final List<String> alphabets = List.generate(
    26,
    (index) => String.fromCharCode('A'.codeUnitAt(0) + index),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onWordsLoaded(List<Word> words) {
    setState(() {
      _currentWords = words;
    });
  }

  void _onSearchChanged(String query) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _currentSearchQuery = query;
        _isScrolling = false;
      });
    });
  }

  void _scrollToAlphabet(String alphabet) async {
    // Add safety checks and prevent multiple scroll operations
    if (_isScrolling ||
        !itemScrollController.isAttached ||
        _currentWords.isEmpty ||
        _currentSearchQuery.isNotEmpty) {
      // Don't scroll during search
      return;
    }

    setState(() {
      _isScrolling = true;
    });

    try {
      final int indexToScroll = _currentWords.indexWhere(
        (word) =>
            word.word.isNotEmpty &&
            word.word.toUpperCase().startsWith(alphabet),
      );

      if (indexToScroll != -1 && indexToScroll < _currentWords.length) {
        await itemScrollController.scrollTo(
          index: indexToScroll,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tidak ada kata yang dimulai dengan "$alphabet"'),
            ),
          );
        }
      }
    } catch (e) {
      print('Error scrolling to alphabet: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isScrolling = false;
        });
      }
    }
  }

  Widget _buildWordList() {
    if (_currentWords.isEmpty) {
      return Container(); // Will show loading or empty state from child widgets
    }

    return ScrollablePositionedList.builder(
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
      itemCount: _currentWords.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        if (index >= _currentWords.length) {
          return const SizedBox.shrink();
        }
        final word = _currentWords[index];
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
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
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

  Widget _buildAlphabetSidebar() {
    if (_currentWords.isEmpty || _currentSearchQuery.isNotEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 28,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      alignment: Alignment.center,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: alphabets.length,
        itemBuilder: (context, index) {
          final alphabet = alphabets[index];
          return InkWell(
            onTap: () => _scrollToAlphabet(alphabet),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 3.0,
                horizontal: 4.0,
              ),
              child: Text(
                alphabet,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
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

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: const Icon(Icons.search),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                ),
                labelColor: Theme.of(context).colorScheme.onPrimary,
                unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
                labelStyle: Theme.of(context).textTheme.headlineMedium,
                unselectedLabelStyle:
                    Theme.of(context).textTheme.headlineMedium,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [Tab(text: 'Semua'), Tab(text: 'Koleksimu')],
              ),
            ),

            const SizedBox(height: 16),

            // Content Area with Scrollable and Alphabet Sidebar
            Expanded(
              child: Row(
                children: [
                  // Main Content Area
                  Expanded(
                    child: Stack(
                      children: [
                        // Tab Content (Hidden, only for data processing)
                        Offstage(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              NormalDictionary(
                                onWordsLoaded: _onWordsLoaded,
                                searchQuery: _currentSearchQuery,
                              ),
                              SeenWordsDictionary(
                                onWordsLoaded: _onWordsLoaded,
                                searchQuery: _currentSearchQuery,
                              ),
                            ],
                          ),
                        ),
                        // Visible Word List
                        _buildWordList(),
                      ],
                    ),
                  ),
                  // Alphabet Sidebar
                  _buildAlphabetSidebar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
