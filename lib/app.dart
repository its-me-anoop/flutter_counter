import 'package:flutter/material.dart';
import 'package:flutter_counter/counter/counter.dart';

/// A [MaterialApp] which sets the `home` to [CounterPage].

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterPage(),
    );
  }
}
