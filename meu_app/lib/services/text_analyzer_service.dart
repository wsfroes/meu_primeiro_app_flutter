import '../models/text_analysis.dart';

class TextAnalyzerService {
  // Lista de palavras irrelevantes (stop words)
  static final Set<String> _stopWords = <String>{
    'a', 'o', 'que', 'de', 'para', 'com', 'sem', 'mas', 'e', 'ou', 'entre',
    'em', 'por', 'da', 'do', 'as', 'os', 'se', 'um', 'uma', 'é', 'no', 'na',
    'nos', 'nas', 'ao', 'aos', 'à', 'às', 'seu', 'sua', 'meu', 'minha',
    'dele', 'dela', 'isso', 'isto', 'aquele', 'aquela', 'pode', 'podem',
    'ser', 'são', 'está', 'estão', 'têm', 'tem', 'ter'
  };

  // Método principal que executa todas as análises
  TextAnalysis analyzeText(String text) {
    if (text.trim().isEmpty) {
      return TextAnalysis.empty();
    }

    final totalWords = _countTotalWords(text);
    final readingTime = _estimateReadingTime(totalWords);
    final sentenceCount = _countSentences(text);
    final charCounts = _countCharacters(text);
    final allFrequencies = _countWordFrequency(text);
    
    // Pega apenas as top 10 palavras mais frequentes
    final sortedEntries = allFrequencies.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top10 = Map.fromEntries(sortedEntries.take(10));

    return TextAnalysis(
      totalWordCount: totalWords,
      sentenceCount: sentenceCount,
      readingTime: readingTime,
      charCountWithSpaces: charCounts['withSpaces']!,
      charCountWithoutSpaces: charCounts['withoutSpaces']!,
      wordFrequency: top10,
    );
  }

  // Tempo estimado de leitura
  String _estimateReadingTime(int wordCount) {
    const int wordsPerMinute = 250;
    if (wordCount == 0) {
      return '0 segundos';
    }

    double minutes = wordCount / wordsPerMinute;
    if (minutes < 1.0) {
      int seconds = (minutes * 60).round();
      return '$seconds segundos';
    } else {
      int roundedMinutes = minutes.ceil();
      return '$roundedMinutes minutos';
    }
  }

  // Contador de caracteres com e sem espaço
  Map<String, int> _countCharacters(String text) {
    final withSpaces = text.length;
    final textWithoutSpaces = text.replaceAll(RegExp(r'\s'), '');
    final withoutSpaces = textWithoutSpaces.length;
    
    return {
      'withSpaces': withSpaces,
      'withoutSpaces': withoutSpaces,
    };
  }

  // Contador de palavras totais
  int _countTotalWords(String text) {
    if (text.trim().isEmpty) {
      return 0;
    }
    String cleanText = text.replaceAll(RegExp(r'[^\w\s]'), '');
    List<String> words = cleanText
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    return words.length;
  }

  // Contador de frases
  int _countSentences(String text) {
    if (text.trim().isEmpty) {
      return 0;
    }
    final sentenceRegExp = RegExp(r'[.?!](?=\s|$)', multiLine: true);
    final matches = sentenceRegExp.allMatches(text);
    int count = matches.length;
    if (count == 0 && text.trim().isNotEmpty) {
      return 1;
    }
    return count;
  }

  // Contador de palavras frequentes
  Map<String, int> _countWordFrequency(String text) {
    String cleanText = text.toLowerCase().trim();
    
    // Remove acentos
    cleanText = cleanText
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ã', 'a')
        .replaceAll('õ', 'o')
        .replaceAll('â', 'a')
        .replaceAll('ê', 'e')
        .replaceAll('ô', 'o')
        .replaceAll('ç', 'c');
    
    cleanText = cleanText.replaceAll(RegExp(r'[^\w\s]'), '');
    List<String> words = cleanText
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    Map<String, int> frequencyMap = {};
    for (String word in words) {
      if (!_stopWords.contains(word)) {
        frequencyMap[word] = (frequencyMap[word] ?? 0) + 1;
      }
    }
    return frequencyMap;
  }
}