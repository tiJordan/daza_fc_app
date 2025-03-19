import 'package:flutter/material.dart';

class PlayerDetailScreen extends StatelessWidget {
  final String playerName;

  const PlayerDetailScreen({super.key, required this.playerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do $playerName'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Estatísticas de $playerName',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.sports_soccer),
                    title: Text('Jogo 1'),
                    subtitle: Text('Gols: 1, Assistências: 0, Cartões Amarelos: 0, Cartões Vermelhos: 0'),
                  ),
                  ListTile(
                    leading: Icon(Icons.sports_soccer),
                    title: Text('Jogo 2'),
                    subtitle: Text('Gols: 2, Assistências: 1, Cartões Amarelos: 1, Cartões Vermelhos: 0'),
                  ),
                  // Adicione mais ListTiles conforme necessário
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}