import 'package:flutter/material.dart';

class BrowserViewScreen extends StatelessWidget {
  const BrowserViewScreen({super.key, required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.red,
            child: Text('Left panel'),
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
              padding: const EdgeInsets.only(right: 10.0, bottom: 20.0),
              child: content),
        ),
      ],
    );
  }
}
