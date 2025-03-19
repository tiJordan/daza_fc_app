import 'package:src/flutter/material.dart';
import 'home_screen.dart';
import 'players_screen.dart';
import 'diretoria_screen.dart';
import 'calendar_screen.dart';
import 'videos_screen.dart';
import 'insert_statistics_screen.dart';

class AppDrawer extends StatelessWidget {
  final String currentScreen;

  const AppDrawer({super.key, required this.currentScreen});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeScreen(
                      token: '',
                      role:
                          ''), // Certifique-se de passar os parâmetros corretos
                ),
                (route) => false, // Remove todas as telas anteriores
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_library),
            title: const Text('Vídeos'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const VideosScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Calendário'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const CalendarScreen()),
              );
            },
          ),
          //  if (currentScreen == 'Jogadores') // Apenas na tela "Jogadores"
          ExpansionTile(
            leading: const Icon(Icons.people),
            title: const Text('Jogadores'),
            children: [
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Estatísticas'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const PlayersScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Cadastrar Estatísticas'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const InsertStatisticsScreen()),
                  );
                },
              ),
            ],
          ),
          
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Diretoria'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DiretoriaScreen()),
              );
            },
          )
        ],
      ),
    );
  }
}
