import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  final String? titleText;

  SecondPage({this.titleText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleText ?? ''),
      ),
    );
  }
}
