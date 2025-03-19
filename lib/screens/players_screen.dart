// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'app_drawer.dart';
import 'insert_statistics_screen.dart';
import 'home_screen.dart';
import 'diretoria_screen.dart'; // Import da tela Diretoria

class PlayersScreen extends StatefulWidget {
  final List<Map<String, dynamic>> players;

  const PlayersScreen(
      {super.key,
      this.players = const []}); // Parâmetro opcional com valor padrão

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  List<Map<String, dynamic>> players = [];

  @override
  void initState() {
    super.initState();
    fetchPlayers(); // Busca os jogadores ao carregar a tela
  }

  Future<void> fetchPlayers() async {
    final url = Uri.parse('http://192.168.0.141:5000/api/players');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          players = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar jogadores: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas dos Jogadores'),
        backgroundColor: Colors.blueGrey, // Cor do AppBar
      ),
      drawer:
          const AppDrawer(currentScreen: 'Home'), // Adiciona o Drawer na tela
      body: players.isEmpty
          ? const Center(
              child: Text(
                'Nenhum jogador cadastrado.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(player['numero_camisa'].toString()),
                    ),
                    title: Text(player['nome']),
                    subtitle: Text(
                      'Posições: ${player['posicoes']}\n'
                      'Gols: ${player['gols']} | Assistências: ${player['assistencias']} | '
                      'Cartões Amarelos: ${player['cartoes_amarelos']} | Cartões Vermelhos: ${player['cartoes_vermelhos']}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
