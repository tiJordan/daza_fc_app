import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final List<Map<String, dynamic>> _games = [];
  Map<String, dynamic> _newStatistic = {
    'player': '',
    'goals': 0,
    'assists': 0,
    'yellowCards': 0,
    'redCards': 0,
  };

  Future<void> _saveStatistic() async {
    final url = Uri.parse('http://192.168.0.141:5000/api/statistics');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(_newStatistic),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context); // Fecha o diálogo
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Estatísticas salvas com sucesso!')),
        );
        setState(() {
          _games.add(_newStatistic); // Atualiza a lista localmente
        });
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

  void _addStatistic() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Adicionar Estatística'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                hint: const Text('Selecione o Jogador'),
                items: const [
                  DropdownMenuItem(value: 'Jogador A', child: Text('Jogador A')),
                  DropdownMenuItem(value: 'Jogador B', child: Text('Jogador B')),
                ],
                onChanged: (value) => _newStatistic['player'] = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Gols'),
                keyboardType: TextInputType.number,
                onChanged: (value) => _newStatistic['goals'] = int.tryParse(value) ?? 0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Assistências'),
                keyboardType: TextInputType.number,
                onChanged: (value) => _newStatistic['assists'] = int.tryParse(value) ?? 0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Cartões Amarelos'),
                keyboardType: TextInputType.number,
                onChanged: (value) => _newStatistic['yellowCards'] = int.tryParse(value) ?? 0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Cartões Vermelhos'),
                keyboardType: TextInputType.number,
                onChanged: (value) => _newStatistic['redCards'] = int.tryParse(value) ?? 0,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: _saveStatistic, // Chama o método para salvar as estatísticas
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas'),
      ),
      body: ListView.builder(
        itemCount: _games.length,
        itemBuilder: (context, index) {
          final game = _games[index];
          return ListTile(
            title: Text(game['player']),
            subtitle: Text(
              'Gols: ${game['goals']}, Assistências: ${game['assists']}, '
              'Amarelos: ${game['yellowCards']}, Vermelhos: ${game['redCards']}',
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addStatistic,
        child: const Icon(Icons.add),
      ),
    );
  }
}