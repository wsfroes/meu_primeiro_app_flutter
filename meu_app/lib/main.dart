import 'package:flutter/material.dart';

void main() {
  runApp(const TextAnalyzerApp());
}

class TextAnalyzerApp extends StatelessWidget {
  const TextAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Analisador de Texto',
      // Trocando para a cor Teal (Verde/Azul)
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _textController = TextEditingController();
  // Variáveis de estado
  Map<String, int> _wordFrequencyResults = {};
  bool _showResults = false;
  int _sentenceCount = 0;
  String _readingTime = '';
  int _totalWordCount = 0;
  int _charCountWithSpaces = 0;
  int _charCountWithoutSpaces = 0;
  // Lista de palavras irrelevantes (stop words).
  static final Set<String> _stopWords = <String>{
    'a','o','que','de','para','com','sem','mas','e','ou','entre','em', 'por','da','do','as','os','se','um','uma','é','no','na','nos','nas','ao','aos','à','às','seu','sua','meu','minha','dele','dela','isso','isto','aquele','aquela','pode','podem','ser','são','está','estão','têm','tem','ter'};
// ----------------------------------------------------------------------
// LÓGICAS DAS ANÁLISES
// ----------------------------------------------------------------------
  //Tempo estimado de leitura
  void _estimateReadingTime(int wordCount) {
    const int wordsPerMinute = 250;
    if (wordCount == 0) {
      _readingTime = '0 segundos';
      return;
    }

    double minutes = wordCount / wordsPerMinute;
    if (minutes < 1.0) {
      int seconds = (minutes * 60).round();
      _readingTime = '$seconds segundos';
    } else {
      int roundedMinutes = minutes.ceil();
      _readingTime = '$roundedMinutes minutos';
    }
  }
  //Contador de caracteres com e sem espaço
  void _countCharacters(String text) {
    _charCountWithSpaces = text.length;
    String textWithoutSpaces = text.replaceAll(RegExp(r'\s'), '');
    _charCountWithoutSpaces = textWithoutSpaces.length;
  }

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
  //Contador de Frases
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
  //Contador de palavras frequentes
  Map<String, int> _countWordFrequency(String text) {
    String cleanText = text.toLowerCase().trim();
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
// ----------------------------------------------------------------------
// COORDENAÇÃO
// ----------------------------------------------------------------------
  // Função do botão Analisar
  void _analyzeText() {
    String text = _textController.text;
    if (text.trim().isEmpty) {
      //guard clause (guarda da função) - Limpa os resultados se o texto estiver vazio
      setState(() {
        _showResults = false;
        _wordFrequencyResults = {};
        _sentenceCount = 0;
        _totalWordCount = 0;
        _readingTime = '';
        _charCountWithSpaces = 0;
        _charCountWithoutSpaces = 0;
      });
      // Remove qualquer SnackBar anterior e mostra o novo
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite um texto para analisar.'),
          backgroundColor: Colors.redAccent,
      ),
    );
      return;
    }
    int totalWords = _countTotalWords(text);
    _estimateReadingTime(totalWords);
    int sentenceCount = _countSentences(text);
    _countCharacters(text);
    Map<String, int> allFrequencies = _countWordFrequency(text);
    var sortedEntries = allFrequencies.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    Map<String, int> top10 = Map.fromEntries(sortedEntries.take(10));
    setState(() {
      _wordFrequencyResults = top10;
      _showResults = true;
      _sentenceCount = sentenceCount;
      _totalWordCount = totalWords;
    });
  }
  //Função do botão Limpar
  void _clearText() {
    _textController.clear();
    setState(() {
      _showResults = false;
      _wordFrequencyResults = {};
      _sentenceCount = 0;
      _totalWordCount = 0;
      _readingTime = '0 segundos';
      _charCountWithSpaces = 0;
      _charCountWithoutSpaces = 0;
    });
  }
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  //Caixa de diálogo com o usuário
  Future<bool?> _showConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // O usuário deve clicar em um botão
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Limpeza'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Você tem certeza de que deseja limpar o texto e a análise?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false); // Retorna 'false'
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                Navigator.of(context).pop(true); // Retorna 'true'
              },
            ),
          ],
        );
      },
    );
  }
// ----------------------------------------------------------------------
// WIDGETS DE DESIGN
// ----------------------------------------------------------------------
  // Widget para criar os botões "Analisar" e "Limpar".
  Widget _buildActionButton({
    required String text,
    required Color? color,
    required VoidCallback onPressed,
    required Color shadowColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  // Widget auxiliar para criar um card de métrica individual.
  // Adicionado o parâmetro 'width'
  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required double width, // Parâmetro de largura
  }) {
    return Container(
      // USANDO o parâmetro 'width'
      width: width,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.teal.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withAlpha(50),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal.shade700),
          const SizedBox(height: 8.0),
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Widget que agrupa e exibe todos os 5 cards de resumo.
  Widget _buildSummaryCards() {
    // Define uma largura maior para os cards de caracteres
    const double wideCardWidth = 180;
    // Define a largura original para os outros cards
    const double normalCardWidth = 150;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),

        // Barra de Título "Resumo da Análise" (Mantido)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.teal.shade200, width: 1.0),
          ),
          child: const Center(
            child: Text(
              'Resumo da Análise',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),

        // --- GRUPO DE CARDS (Substituindo Wrap por Column com Rows) ---
        Column(
          children: [
            // LINHA SUPERIOR (3 Cards Menores)
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceAround, // Distribui o espaço entre os cards
              children: [
                // 1. Palavras Totais
                _buildMetricCard(
                  title: 'Palavras Totais',
                  value: _totalWordCount.toString(),
                  icon: Icons.sort_by_alpha,
                  width: normalCardWidth, // Largura menor
                ),
                // 2. Total de Frases (Título Renomeado)
                _buildMetricCard(
                  title: 'Total de Frases',
                  value: _sentenceCount.toString(),
                  icon: Icons.format_quote,
                  width: normalCardWidth, // Largura menor
                ),
                // 3. Tempo de Leitura
                _buildMetricCard(
                  title: 'Tempo de Leitura',
                  value: _readingTime,
                  icon: Icons.timer,
                  width: normalCardWidth, // Largura menor
                ),
              ],
            ),

            const SizedBox(height: 16.0), // Espaço entre as linhas de cards
            // LINHA INFERIOR (2 Cards Maiores)
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // Distribui o espaço entre os 2 cards grandes
              children: [
                // 4. Caracteres com Espaço (Largura Aumentada)
                _buildMetricCard(
                  title: 'Caracteres (c/ Espaço)',
                  value: _charCountWithSpaces.toString(),
                  icon: Icons.space_bar,
                  width: wideCardWidth, // Largura maior
                ),
                // 5. Caracteres sem Espaço (Largura Aumentada)
                _buildMetricCard(
                  title: 'Caracteres (s/ Espaço)',
                  value: _charCountWithoutSpaces.toString(),
                  icon: Icons.short_text,
                  width: wideCardWidth, // Largura maior
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Widget para a lista de frequência de palavras.
  Widget _buildWordFrequencyList() {
    if (_wordFrequencyResults.isEmpty) {
      return const Center(child: Text('Nenhuma palavra relevante encontrada.'));
    }

    return ListView.builder(
      itemCount: _wordFrequencyResults.length,
      itemBuilder: (context, index) {
        final entry = _wordFrequencyResults.entries.elementAt(index);
        return ListTile(
          leading: CircleAvatar(
            // ALTERAÇÃO: Círculo para Teal
            backgroundColor: Colors.teal.shade100,
            child: Text(
              '${index + 1}',
              style: TextStyle(
                // ALTERAÇÃO: Número para Teal
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
    );
  }

// ----------------------------------------------------------------------
// LAYOUT DA TELA
// ----------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(
          children: [
            Positioned(
              top: 2.0,
              left: 2.0,
              child: Text(
                'Analisador de Texto',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withAlpha(128),
                ),
              ),
            ),
            const Text(
              'Analisador de Texto',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        // ALTERAÇÃO: AppBar para Teal
        backgroundColor: Colors.teal.shade700,
        elevation: 20,
        shadowColor: Colors.black,
      ),
      bottomNavigationBar: Container(
        height: 40.0,
        // ALTERAÇÃO: BottomBar para Teal
        decoration: BoxDecoration(
          color: Colors.teal.shade700,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(128),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Desenvolvido por Walltech Soluções Inteligentes',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Área do TextField
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      // ALTERAÇÃO: Sombra do TextField para Teal
                      color: Colors.teal.withAlpha(50),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 200.0,
                  child: TextField(
                    controller: _textController,
                    maxLines: null,
                    expands: true,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Digite ou cole seu texto aqui...',
                      labelText: 'Seu Texto',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        // ALTERAÇÃO: Borda do TextField para Teal
                        borderSide: BorderSide(
                          color: Colors.teal.shade700,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        // ALTERAÇÃO: Borda do TextField para Teal
                        borderSide: BorderSide(
                          color: Colors.teal.shade700,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        // ALTERAÇÃO: Borda do TextField para Teal
                        borderSide: BorderSide(
                          color: Colors.teal.shade700,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // Botões Analisar (Verde) e Limpar (Vermelho)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // O botão Analisar (Green) continua em verde, como cor de ação
                  _buildActionButton(
                    text: 'Analisar',
                    color: Colors.green.shade700,
                    onPressed: _analyzeText,
                    shadowColor: Colors.green.withAlpha(100),
                  ),
                  _buildActionButton(
                    text: 'Limpar',
                    color: Colors.red.shade700,
                    onPressed: () async { 
                      final bool? confirmed = await _showConfirmationDialog();
                       if (confirmed == true) {
                         _clearText(); // Só executa a limpeza se confirmado
                       }
                     },
                     shadowColor: Colors.red.withAlpha(100),
                   ),
                ],
              ),        
              // Seção de Resultados.
              if (_showResults)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Resumo da Análise
                    _buildSummaryCards(),

                    const SizedBox(height: 32.0),
                    const Divider(),

                    // Título da Frequência de Palavras
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(
                        // ALTERAÇÃO: Cor de fundo para Teal
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(8.0),
                        // ALTERAÇÃO: Borda para Teal
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
                            // ALTERAÇÃO: Texto para Teal
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Lista de Frequência de Palavras
                    Container(
                      height: 170.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        // ALTERAÇÃO: Borda da lista para Teal
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
                      child: _buildWordFrequencyList(),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}