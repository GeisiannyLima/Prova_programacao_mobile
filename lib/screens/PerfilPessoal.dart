import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../models/BD.dart'; // Certifique-se de ajustar o caminho conforme necessário

class PerfilPessoal extends StatefulWidget {
  const PerfilPessoal({super.key});

  @override
  State<PerfilPessoal> createState() => _PerfilPessoalState();
}

class _PerfilPessoalState extends State<PerfilPessoal> {
  bool isFixedAccounts =
      true; // Estado para alternar entre contas fixas e variáveis
  late Future<User> _userFuture; // Alterado para Future<User>

  final List<Map<String, String>> fixedAccounts = [
    {'name': 'Mercado', 'value': '1.457,25'},
    {'name': 'Água', 'value': '45,25'},
    {'name': 'Energia', 'value': '57,20'},
    {'name': 'Streaming', 'value': '200,25'},
  ];

  final List<Map<String, String>> variableAccounts = [
    {'name': 'Internet', 'value': '99,90'},
    {'name': 'Transporte', 'value': '150,00'},
    {'name': 'Lazer', 'value': '300,00'},
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String email = ModalRoute.of(context)!.settings.arguments as String;
    _userFuture = _loadUser(email);
  }

  Future<User> _loadUser(String email) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/usuarios.json';
    final file = File(path);

    if (file.existsSync()) {
      final String response = await file.readAsString();
      final List<dynamic> data = json.decode(response);
      final allUsers = data.map((json) => User.fromJson(json)).toList();
      return allUsers.firstWhere((user) => user.email == email);
    } else {
      throw Exception("Usuário não encontrado");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<User>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Carregando...');
            } else if (snapshot.hasError) {
              return Text('Erro ao carregar perfil');
            } else {
              final user = snapshot.data!;
              return Text('${user.name} - Perfil');
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<User>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Nenhum dado encontrado.'));
          } else {
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            child: Text(
                              user.name[0], // Exibe a inicial do nome
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          SizedBox(width: 16),
                          Text(
                            user.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        child: Icon(
                          Icons.bar_chart, // Ícone de gráfico de barras
                          size: 45,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/grafico',
                              arguments: user.email);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Saldo Geral',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '4.457,25', // Este valor deve ser dinâmico se necessário
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isFixedAccounts = true; // Muda para contas fixas
                          });
                        },
                        child: Text(
                          'Contas Fixas',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: isFixedAccounts ? Colors.blue : Colors.grey,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isFixedAccounts =
                                false; // Muda para contas variáveis
                          });
                        },
                        child: Text(
                          'Contas Variáveis',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: !isFixedAccounts ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView(
                        children: (isFixedAccounts
                                ? fixedAccounts
                                : variableAccounts)
                            .map((account) => Column(
                                  children: [
                                    buildListItem(
                                        account['name']!, account['value']!),
                                    Divider(color: Colors.grey, thickness: 0),
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildListItem(String name, String value) {
    return ListTile(
      title: Text(name, style: TextStyle(fontSize: 18)),
      trailing: Text(value, style: TextStyle(fontSize: 18)),
    );
  }
}
