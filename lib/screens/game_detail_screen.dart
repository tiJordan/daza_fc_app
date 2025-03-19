import 'package:flutter/material.dart';

class GameDetailScreen extends StatelessWidget {
  final Map<String, String> game;

  const GameDetailScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Jogo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Data: ${game['date']}', style: const TextStyle(fontSize: 18)),
            Text('Adversário: ${game['opponent']}', style: const TextStyle(fontSize: 18)),
            Text('Local: ${game['location']}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            FloatingActionButton(
              onPressed: () => _editGame(context),
              child: const Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }

  void _editGame(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Jogo'),
          content: const Text('Diálogo para editar data, adversário, local'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}