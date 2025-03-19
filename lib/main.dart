import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const DazaFCApp());
}

class DazaFCApp extends StatelessWidget {
  const DazaFCApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DAZA FC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(), // Tela inicial de login
      // Remova ou comente a rota '/home' para evitar instanciar HomeScreen sem par�metros.
      // routes: {
      //   '/home': (context) => const HomeScreen(), // Isso gera o erro!
      // },
    );
  }
}
