import 'package:flutter/material.dart';
import 'package:task1/text_control.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Task 1',
          ),
        ),
        body: const TextControl(),
      ),
    );
  }
}
