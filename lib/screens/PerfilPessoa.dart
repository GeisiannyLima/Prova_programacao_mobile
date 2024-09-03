import 'package:flutter/material.dart';
import '../models/BD.dart'; // Certifique-se de ajustar o caminho conforme necessário

class PerfilPessoa extends StatefulWidget {
  const PerfilPessoa({super.key});

  @override
  State<PerfilPessoa> createState() => _PerfilPessoaState();
}

class _PerfilPessoaState extends State<PerfilPessoa> {
  bool isFixedAccounts =
      true; // Estado para alternar entre contas fixas e variáveis
  late User
      _user; // Adiciona uma variável para armazenar as informações da pessoa

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
    // Obtém o argumento passado para a tela
    _user = ModalRoute.of(context)!.settings.arguments as User;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_user.name} - Perfil'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
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
                        _user.name[0], // Exibe a inicial do nome
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      _user.name,
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
                        arguments: _user.email);
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
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '4.457,25', // Este valor deve ser dinâmico se necessário
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                      isFixedAccounts = false; // Muda para contas variáveis
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
                  children: (isFixedAccounts ? fixedAccounts : variableAccounts)
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
