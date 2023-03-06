import 'package:flutter/material.dart';

class Text2 extends StatelessWidget {
  final String text;

  const Text2(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 36,
      ),
    );
  }
}
