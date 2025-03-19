import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'app_drawer.dart';
import 'game_detail_screen.dart';

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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Jogo'),
          content: const Text('Diálogo para adicionar data, adversário, local'),
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

  void _showGameDetails(Map<String, String> game, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameDetailScreen(game: game),
      ),
    );
  }
}
