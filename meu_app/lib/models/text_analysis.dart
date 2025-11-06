class TextAnalysis {
  final int totalWordCount;
  final int sentenceCount;
  final String readingTime;
  final int charCountWithSpaces;
  final int charCountWithoutSpaces;
  final Map<String, int> wordFrequency;

  TextAnalysis({
    required this.totalWordCount,
    required this.sentenceCount,
    required this.readingTime,
    required this.charCountWithSpaces,
    required this.charCountWithoutSpaces,
    required this.wordFrequency,
  });

  // Construtor para criar uma análise vazia
  factory TextAnalysis.empty() {
    return TextAnalysis(
      totalWordCount: 0,
      sentenceCount: 0,
      readingTime: '0 segundos',
      charCountWithSpaces: 0,
      charCountWithoutSpaces: 0,
      wordFrequency: {},
    );
  }

  // Verifica se tem resultados
  bool get hasResults => totalWordCount > 0;
}