import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adibasa_app/theme/theme.dart';
import '../widgets/seen_words_dictionary.dart';
import '../widgets/normal_dictionary.dart';

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

class _KamusPageState extends State<KamusPage> {
  bool _showSeenWords = false;

  void _toggleDictionaryMode() {
    setState(() {
      _showSeenWords = !_showSeenWords;
    });
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
                _showSeenWords ? 'Kata Yang Dijumpai' : 'Kamus',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),

            // Search bar dan Toggle Button
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
                        onChanged: (query) {
                          // Pass search query to child widgets
                          if (_showSeenWords) {
                            // Handle seen words search
                          } else {
                            // Handle normal dictionary search
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1.0,
                        ),
                        left: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1.0,
                        ),
                        right: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1.0,
                        ),
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: 3.0,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ElevatedButton(
                      onPressed: _toggleDictionaryMode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 10,
                        shadowColor: Colors.transparent,
                        side: BorderSide.none,
                      ),
                      child: Text(
                        _showSeenWords ? 'Kata Yang Dijumpai' : 'Kamus',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child:
                  _showSeenWords
                      ? const SeenWordsDictionary()
                      : const NormalDictionary(),
            ),
          ],
        ),
      ),
    );
  }
}
