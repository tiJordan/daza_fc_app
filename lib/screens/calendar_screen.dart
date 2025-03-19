import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'app_drawer.dart';
import 'game_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  final DateTime _focusedDay = DateTime.now();
  final Map<DateTime, List<Map<String, String>>> _events = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário'),
        backgroundColor: Colors.blueGrey, // Cor do AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addGame(context),
          ),
        ],
      ),
      drawer: const AppDrawer(currentScreen: 'Home'), // Adiciona o Drawer
      body: TableCalendar(
        calendarFormat: _calendarFormat,
        focusedDay: _focusedDay,
        eventLoader: (day) => _events[day] ?? [],
        onDaySelected: (selectedDay, focusedDay) {
          if (_events[selectedDay] != null) {
            _showGameDetails(_events[selectedDay]!.first, context);
          }
        },
        firstDay: DateTime(2000, 1, 1),
        lastDay: DateTime(2100, 12, 31),
      ),
    );
  }

  void _addGame(BuildContext context) {
    TextEditingController adversarioController = TextEditingController();
    TextEditingController localController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Jogo'),
          content: Column(
            children: [
              TextButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000), // Corrigido para firstDate
                    lastDate: DateTime(2100), // Corrigido para lastDate
                  );
                  if (picked != null) {
                    selectedDate = picked;
                  }
                },
                child: Text(selectedDate == null
                    ? 'Selecionar Data'
                    : 'Data: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}'),
              ),
              TextField(
                controller: adversarioController,
                decoration: const InputDecoration(labelText: 'Adversário'),
              ),
              TextField(
                controller: localController,
                decoration: const InputDecoration(labelText: 'Local'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedDate != null &&
                    adversarioController.text.isNotEmpty) {
                  // Enviar para o backend
                  final response = await http.post(
                    Uri.parse('http://192.168.0.141:5000/api/jogos'),
                    body: json.encode({
                      'data': selectedDate!.toIso8601String(),
                      'adversario': adversarioController.text,
                      'local': localController.text,
                    }),
                  );
                  if (response.statusCode == 200) {
                    print('Game added successfully: ${response.body}');
                  } else {
                    print('Failed to add game: ${response.statusCode}');
                  }
                  Navigator.pop(context);
                  setState(() {}); // Atualiza a UI
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _showGameDetails(Map<String, String> game, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameDetailScreen(game: game),
      ),
    );
  }
}
