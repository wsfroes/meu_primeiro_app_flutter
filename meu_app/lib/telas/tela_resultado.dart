import 'package:flutter/material.dart';
import '../models/text_analysis.dart'; // Precisa saber o que é um TextAnalysis
import '../widgets/summary_cards.dart'; // Vai usar este widget
import '../widgets/word_frequency_list.dart'; // Vai usar este widget

class TelaResultados extends StatelessWidget {
  // 1. O "contrato": esta tela EXIGE um objeto TextAnalysis para ser construída.
  final TextAnalysis analysis;

  const TelaResultados({
    super.key,
    required this.analysis, // O construtor recebe a análise
  });

  @override
  Widget build(BuildContext context) {
    // 2. Usamos um Scaffold para dar uma aparência de "página"
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados da Análise'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 3. Este é o bloco de código que você "puxou" da tela_principal
              // Ele agora usa o objeto 'analysis' que veio pelo construtor.
              SummaryCards(analysis: analysis),
              const SizedBox(height: 16.0),
              const Divider(),
              WordFrequencyList(wordFrequency: analysis.wordFrequency),
            ],
          ),
        ),
      ),
    );
  }
}