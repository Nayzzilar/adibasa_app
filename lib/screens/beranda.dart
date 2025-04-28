import 'package:flutter/material.dart';
import 'package:adibasa_app/navigation/buttom_navbar.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text('Beranda'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text('Firebase Initialized.'),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text('You have pushed the button this many times:'),
              ),
            ),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text('Click button ini'),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavbar(), // panggil navbar di sini
    );
  }
}
