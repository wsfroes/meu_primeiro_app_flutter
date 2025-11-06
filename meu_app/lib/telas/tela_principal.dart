import 'package:flutter/material.dart';
import 'tela_resultado.dart';
import '../models/text_analysis.dart';
import '../services/text_analyzer_service.dart';
import '../widgets/action_buttons.dart';
//import '../widgets/summary_cards.dart';
//import '../widgets/word_frequency_list.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final TextEditingController _textController = TextEditingController();
  final TextAnalyzerService _analyzerService = TextAnalyzerService();
  
  TextAnalysis _analysis = TextAnalysis.empty();
  bool _showResults = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // Analisa o texto
  void _analyzeText() {
    String text = _textController.text;
    
    if (text.trim().isEmpty) {
      _clearResults();
      _showSnackBar(
        'Por favor, digite um texto para analisar.',
        Colors.redAccent,
      );
      return;
    }

    // 1. Calcula a análise (fora do setState)
    final TextAnalysis analysisResult = _analyzerService.analyzeText(text);

    // 2. Limpa o estado da tela principal (opcional, mas bom)
    setState(() {
      _analysis = analysisResult;
      _showResults = false; // Não mostramos mais aqui
    });

    // 3. NAVEGA para a nova tela, passando os resultados
    var push = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaResultados(analysis: analysisResult),
      ),
    );
  }

  // Limpa o texto e resultados
  void _clearText() {
    _textController.clear();
    _clearResults();
  }

  // Limpa apenas os resultados
  void _clearResults() {
    setState(() {
      _analysis = TextAnalysis.empty();
    });
  }

  // Mostra SnackBar
  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  // Diálogo de confirmação
  Future<bool?> _showConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
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
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  // Handler do botão Limpar
  void _handleClearButton() async {
    final bool? confirmed = await _showConfirmationDialog();
    if (confirmed == true) {
      _clearText();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
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
        elevation: 20,
        shadowColor: Colors.black,
      ),*/
      appBar: AppBar(
        title: const Text('Analisador de Texto'),
        centerTitle: true,
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextField
              _buildTextField(),
              const SizedBox(height: 16.0),

              // Botões
              ActionButtons(
                onAnalyze: _analyzeText,
                onClear: _handleClearButton,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 40.0,
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
    );
  }

  // Widget do TextField
  Widget _buildTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
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
              borderSide: BorderSide(
                color: Colors.teal.shade700,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: Colors.teal.shade700,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: Colors.teal.shade700,
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}