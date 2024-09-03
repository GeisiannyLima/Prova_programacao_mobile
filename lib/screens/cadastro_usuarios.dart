import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../models/BD.dart'; // Certifique-se de que essa importação está correta e a classe User está definida em BD.dart
import '../tools/input/main.dart'; // Certifique-se de que inputWidget está definido aqui

class CadastroUsuarios extends StatefulWidget {
  const CadastroUsuarios({super.key});

  @override
  State<CadastroUsuarios> createState() => _CadastroUsuariosState();
}

class _CadastroUsuariosState extends State<CadastroUsuarios> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rendaFixaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro de Usuarios"),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: <Widget>[
              inputWidget(emailController, context, "E-mail",
                  "Ex.: mail@gmail.com", false),
              inputWidget(passwordController, context, "Password", '', true),
              inputWidget(
                  nomeController, context, "Nome", "Ex.: João Silva", false),
              inputWidget(rendaFixaController, context, "Renda Fixa",
                  "Ex.: 10000", false),
              ElevatedButton(
                onPressed: () async {
                  if (_validateInputs()) {
                    final newUser = User(
                      email: emailController.text,
                      password: passwordController.text,
                      name: nomeController.text,
                      rendaFixa:
                          double.tryParse(rendaFixaController.text) ?? 0.0,
                    );

                    await addUser(newUser);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Sucesso'),
                          content:
                              const Text('Usuário cadastrado com sucesso!'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.pushNamed(context, '/');
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Erro'),
                          content: const Text(
                              'Por favor, preencha todos os campos corretamente.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateInputs() {
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        nomeController.text.isNotEmpty &&
        rendaFixaController.text.isNotEmpty &&
        double.tryParse(rendaFixaController.text) != null;
  }

  Future<void> addUser(User newUser) async {
    List<User> users = await loadUsers();
    users.add(newUser);
    await saveUsers(users);
  }

  Future<List<User>> loadUsers() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/usuarios.json';
    final file = File(path);

    if (file.existsSync()) {
      final String response = await file.readAsString();
      final List<dynamic> data = json.decode(response);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      print("Arquivo não encontrado. Um novo arquivo será criado.");
      return [];
    }
  }

  Future<void> saveUsers(List<User> users) async {
    final String jsonString =
        json.encode(users.map((user) => user.toJson()).toList());
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/usuarios.json';
    final file = File(path);

    print("Salvando dados no caminho: $path");
    print("Dados: $jsonString");

    await file.writeAsString(jsonString);
    print("Usuários salvos com sucesso.");
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rendaFixaController.dispose();
    super.dispose();
  }
}
