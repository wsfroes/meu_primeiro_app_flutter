import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onAnalyze;
  final VoidCallback onClear;

  const ActionButtons({
    super.key,
    required this.onAnalyze,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          text: 'Analisar',
          color: Colors.green.shade700,
          onPressed: onAnalyze,
          shadowColor: Colors.green.withAlpha(100),
        ),
        _buildActionButton(
          text: 'Limpar',
          color: Colors.red.shade700,
          onPressed: onClear,
          shadowColor: Colors.red.withAlpha(100),
        ),
      ],
    );
  }

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
}