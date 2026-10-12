import 'package:flutter/material.dart';

class TelaSugestoes extends StatelessWidget {
  final dynamic title;

  const TelaSugestoes({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sugestões')),
      body: Center(
        child: Text("Sugestões"),
      ),
    );
  }
}