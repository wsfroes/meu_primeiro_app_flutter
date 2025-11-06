import 'package:flutter/material.dart';
import '../models/text_analysis.dart';
import 'metric_card.dart';

class SummaryCards extends StatelessWidget {
  final TextAnalysis analysis;

  const SummaryCards({
    super.key,
    required this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    const double wideCardWidth = 180;
    const double normalCardWidth = 150;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),
        // Grupo de Cards
        Column(
          children: [
            // LINHA SUPERIOR (3 Cards Menores)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MetricCard(
                  title: 'Palavras Totais',
                  value: analysis.totalWordCount.toString(),
                  icon: Icons.sort_by_alpha,
                  width: normalCardWidth,
                ),
                MetricCard(
                  title: 'Total de Frases',
                  value: analysis.sentenceCount.toString(),
                  icon: Icons.format_quote,
                  width: normalCardWidth,
                ),
                MetricCard(
                  title: 'Tempo de Leitura',
                  value: analysis.readingTime,
                  icon: Icons.timer,
                  width: normalCardWidth,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // LINHA INFERIOR (2 Cards Maiores)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MetricCard(
                  title: 'Caracteres (c/ Espaço)',
                  value: analysis.charCountWithSpaces.toString(),
                  icon: Icons.space_bar,
                  width: wideCardWidth,
                ),
                MetricCard(
                  title: 'Caracteres (s/ Espaço)',
                  value: analysis.charCountWithoutSpaces.toString(),
                  icon: Icons.short_text,
                  width: wideCardWidth,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}