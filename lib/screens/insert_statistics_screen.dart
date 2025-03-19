import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necessário para FilteringTextInputFormatter
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'players_screen.dart';

class InsertStatisticsScreen extends StatefulWidget {
  const InsertStatisticsScreen({super.key});

  @override
  State<InsertStatisticsScreen> createState() => _InsertStatisticsScreenState();
}

class _InsertStatisticsScreenState extends State<InsertStatisticsScreen> {
  final TextEditingController playerNameController = TextEditingController();
  final TextEditingController goalsController = TextEditingController();
  final TextEditingController assistsController = TextEditingController();
  final TextEditingController yellowCardsController = TextEditingController();
  final TextEditingController redCardsController = TextEditingController();

  Future<void> saveStatistics() async {
    final url = Uri.parse('http://192.168.0.141:5000/api/statistics');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({
          'player': playerNameController.text,
          'goals': int.tryParse(goalsController.text) ?? 0,
          'assists': int.tryParse(assistsController.text) ?? 0,
          'yellowCards': int.tryParse(yellowCardsController.text) ?? 0,
          'redCards': int.tryParse(redCardsController.text) ?? 0,
        }),
      );

      if (response.statusCode == 200) {
        // Exibe o diálogo de sucesso
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Sucesso'),
            content: const Text('Estatísticas cadastradas com sucesso!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Fecha o diálogo
                },
                child: const Text('Cadastrar Outra'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Fecha o diálogo
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            PlayersScreen(players: [])), // Navega para PlayersScreen
                  );
                },
                child: const Text('Ir para Jogadores'),
              ),
            ],
          ),
        );
      } else {
        final errorData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${errorData['error']}')),
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
        title: const Text('Cadastrar Estatísticas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: playerNameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Jogador',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: goalsController,
                decoration: const InputDecoration(
                  labelText: 'Gols',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ], // Apenas números inteiros
              ),
              const SizedBox(height: 16),
              TextField(
                controller: assistsController,
                decoration: const InputDecoration(
                  labelText: 'Assistências',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ], // Apenas números inteiros
              ),
              const SizedBox(height: 16),
              TextField(
                controller: yellowCardsController,
                decoration: const InputDecoration(
                  labelText: 'Cartões Amarelos',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ], // Apenas números inteiros
              ),
              const SizedBox(height: 16),
              TextField(
                controller: redCardsController,
                decoration: const InputDecoration(
                  labelText: 'Cartões Vermelhos',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ], // Apenas números inteiros
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed:
                    saveStatistics, // Chama a função para salvar as estatísticas
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
