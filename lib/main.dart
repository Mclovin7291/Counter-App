import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

// Window configuration constants
const double windowWidth = 360;
const double windowHeight = 640;

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Age Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

/// Simplest possible model, with just one field.
///
/// [ChangeNotifier] is a class in `flutter:foundation`. [Counter] does
/// _not_ depend on Provider.
class Counter with ChangeNotifier {
  int age= 0;

  void increment() {
    age += 1;
    notifyListeners();
  }
  void decrement() {
    age -= 1;
    if (age < 0) {
      age = 0;
    }
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Age Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<Counter>(
                  builder: (context, counter, child) => Text(
                    'I am ${counter.age} years old',
                    style: Theme.of(context).textTheme.headlineMedium,
                    
                  ),
                ),
              ],
            ),
            const SizedBox(width: 32),  // Add some space between text and buttons
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,  // Specify desired width here
                  child: FloatingActionButton(
                    onPressed: () => context.read<Counter>().increment(),
                    tooltip: 'Increment',
                    child: const Text('Increase Age'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 150,  // Match the width for consistency
                  child: FloatingActionButton(
                    onPressed: () => context.read<Counter>().decrement(),
                    tooltip: 'Decrement',
                    child: const Text('Decrease Age'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}