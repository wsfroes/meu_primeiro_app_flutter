import 'package:flutter/material.dart';

class WordFrequencyList extends StatelessWidget {
  final Map<String, int> wordFrequency;

  const WordFrequencyList({
    super.key,
    required this.wordFrequency,
  });

  @override
  Widget build(BuildContext context) {
    if (wordFrequency.isEmpty) {
      return const Center(
        child: Text('Nenhuma palavra relevante encontrada.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título da Frequência de Palavras
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Colors.teal.shade200,
              width: 1.0,
            ),
          ),
          child: const Center(
            child: Text(
              'Frequência de Palavras (Top 10):',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),

        // Lista de Frequência
        Container(
          height: 170.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.teal.shade200,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(50),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListView.builder(
            itemCount: wordFrequency.length,
            itemBuilder: (context, index) {
              final entry = wordFrequency.entries.elementAt(index);
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal.shade100,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: Colors.teal.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  entry.key,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: Text(
                  '${entry.value} vezes',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}