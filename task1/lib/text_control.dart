import 'package:flutter/material.dart';
import './text2.dart';

class TextControl extends StatefulWidget {
  const TextControl({super.key});

  @override
  State<TextControl> createState() => _TextControlState();
}

class _TextControlState extends State<TextControl> {
  var text = 'Initial text';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text2(text),
          ElevatedButton(
            onPressed: () => setState(() {
              text = 'Text updated';
            }),
            child: const Text(
              'Change text',
            ),
          )
        ],
      ),
    );
  }
}
