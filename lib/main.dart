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
  int age = 0;

  String getMessage() {
    if (age <= 12) {
      return "You're a child!";
    } else if (age <= 19) {
      return "Teenager time!";
    } else if (age <= 30) {
      return "You're a young adult!";
    } else if (age <= 50) {
      return "You're an adult now!";
    } else {
      return "Golden years!";
    }
  }

  Color getBackgroundColor() {
    if (age <= 12) {
      return Colors.lightBlue[100]!;
    } else if (age <= 19) {
      return Colors.lightGreen[100]!;
    } else if (age <= 30) {
      return Colors.yellow[100]!;
    } else if (age <= 50) {
      return Colors.orange[100]!;
    } else {
      return Colors.grey[100]!;
    }
  }

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int age = 0;

  void increment() {
    setState(() {
      age++;
    });
  }

  void decrement() {
    setState(() {
      if (age > 0) age--;
    });
  }

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
                Text(
                  'I am $age years old',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 300,
                  child: Slider(
                    value: age.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: age.toString(),
                    onChanged: (double value) {
                      setState(() {
                        age = value.round();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(width: 32),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: FloatingActionButton(
                    onPressed: increment,
                    tooltip: 'Increment',
                    child: const Text('Increase Age'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 150,
                  child: FloatingActionButton(
                    onPressed: decrement,
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