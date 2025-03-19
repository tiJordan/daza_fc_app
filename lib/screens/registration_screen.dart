import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Controllers para os campos de texto
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  int? selectedJerseyNumber;
  String? selectedRole; // Adicionado para seleção de tipo de usuário
  final String baseUrl = 'http://192.168.0.141:5000';

  // Lista de posições disponíveis
  final List<String> positions = [
    'Goleiro',
    'Zagueiro',
    'Lateral',
    'Volante',
    'Meia',
    'Atacante'
  ];
  List<String> selectedPositions = [];

  // Números de 0 a 100
  final List<int> jerseyNumbers = List.generate(101, (index) => index);

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Erro"),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  Future<void> register() async {
    // Validação de campos obrigatórios: nome, posições, número da camisa, senha e tipo de usuário
    if (nameController.text.isEmpty ||
        senhaController.text.isEmpty ||
        selectedPositions.isEmpty ||
        selectedJerseyNumber == null ||
        selectedRole == null) {
      showErrorDialog(
          "Preencha os campos obrigatórios: Nome, Posições, Número da Camisa, Senha e Tipo de Usuário");
      return;
    }

    // Validação do email, se fornecido
    if (emailController.text.isNotEmpty) {
      final regex = RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
      if (!regex.hasMatch(emailController.text)) {
        showErrorDialog("Email inválido");
        return;
      }
    }

    final url = Uri.parse('$baseUrl/api/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({
          'nome': nameController.text,
          'email': emailController.text,
          'telefone': telefoneController.text,
          'posicoes': selectedPositions,
          'numero_camisa': selectedJerseyNumber,
          'senha': senhaController.text,
          'role': selectedRole, // Adicionado campo role
        }),
      );

      if (response.statusCode == 200) {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Sucesso"),
            content: const Text("Cadastro realizado com sucesso!"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Fecha o diálogo
                  Navigator.pop(context); // Fecha a tela de cadastro
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      } else if (response.statusCode == 409) {
        // Código 409 para conflito (usuário ou número da camisa já existe)
        final errorData = json.decode(response.body);
        if (errorData['error'] == 'Usuário já cadastrado') {
          showErrorDialog("Usuário já cadastrado");
        } else if (errorData['error'] == 'Número da camisa já escolhido') {
          showErrorDialog("Número da camisa já escolhido, escolha outro");
        } else {
          showErrorDialog(errorData['error'] ?? 'Falha no cadastro');
        }
      } else {
        final errorData = json.decode(response.body);
        showErrorDialog(errorData['error'] ?? 'Falha no cadastro');
      }
    } catch (e) {
      showErrorDialog('Erro de conexão: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar'),
        backgroundColor: Colors.blueGrey, // Cor do AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Campo para Nome
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Campo para Email (opcional)
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Campo para Telefone (opcional)
            TextField(
              controller: telefoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Botão para seleção de posições
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      title: const Text('Selecione até 2 posições'),
                      content: Column(
                        children: positions
                            .map((pos) => CheckboxListTile(
                                  title: Text(pos),
                                  value: selectedPositions.contains(pos),
                                  onChanged: (selected) {
                                    if (selectedPositions.length < 2 ||
                                        !selected!) {
                                      setState(() {
                                        selected!
                                            ? selectedPositions.add(pos)
                                            : selectedPositions.remove(pos);
                                      });
                                    }
                                  },
                                ))
                            .toList(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Confirmar'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Text(selectedPositions.isEmpty
                  ? 'Selecionar Posições *'
                  : 'Posições: ${selectedPositions.join(', ')}'),
            ),
            const SizedBox(height: 16),

            // Dropdown para seleção do número da camisa
            DropdownButtonFormField<int>(
              value: selectedJerseyNumber,
              decoration: const InputDecoration(
                labelText: 'Número da Camisa *',
                border: OutlineInputBorder(),
              ),
              items: jerseyNumbers.map((int num) {
                return DropdownMenuItem<int>(
                  value: num,
                  child: Text(num.toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedJerseyNumber = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Dropdown para seleção do tipo de usuário
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: const InputDecoration(
                labelText: 'Tipo de Usuário *',
                border: OutlineInputBorder(),
              ),
              items: ['jogador', 'diretoria'].map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role == 'jogador' ? 'Jogador' : 'Diretoria'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRole = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Campo para Senha
            TextField(
              controller: senhaController,
              decoration: const InputDecoration(
                labelText: 'Senha *',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),

            // Botão de Cadastro
            ElevatedButton(
              onPressed: register,
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
