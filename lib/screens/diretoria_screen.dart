// ignore_for_file: use_build_context_synchronously, deprecated_member_use
import 'package:flutter/material.dart';

import 'app_drawer.dart';

class DiretoriaScreen extends StatelessWidget {
  const DiretoriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Área da Diretoria'),
        backgroundColor: Colors.blueGrey, // Cor do AppBar
      ),
      drawer: const AppDrawer(currentScreen: 'Home'), // Adiciona o Drawer
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/diretoria_soon.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
