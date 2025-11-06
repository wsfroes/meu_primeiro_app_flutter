import 'package:flutter/material.dart';
import 'telas/tela_principal.dart';

void main() {
  runApp(const TextAnalyzerApp());
}

class TextAnalyzerApp extends StatelessWidget {
  const TextAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Analisador de Texto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const TelaPrincipal(),
    );
  }
}