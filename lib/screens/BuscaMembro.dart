import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../models/BD.dart'; // Ajuste o caminho conforme necessário

class BuscaMembro extends StatefulWidget {
  const BuscaMembro({super.key});

  @override
  State<BuscaMembro> createState() => _BuscaMembroState();
}

class _BuscaMembroState extends State<BuscaMembro> {
  final buscaController = TextEditingController();
  List<User> members = [];
  List<User> searchResults = [];

  @override
  void initState() {
    super.initState();
    loadUsers(); // Carregar usuários no início
  }

  Future<void> loadUsers() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/usuarios.json';
    final file = File(path);

    if (file.existsSync()) {
      final String response = await file.readAsString();
      final List<dynamic> data = json.decode(response);
      setState(() {
        members = data.map((json) => User.fromJson(json)).toList();
      });
    }
  }

  void searchMembers() {
    final query = buscaController.text.toLowerCase();
    setState(() {
      searchResults = members
          .where((user) => user.email.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> addMemberToGroup(User user) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/grupos.json';
    final file = File(path);

    List<Grupo> grupos = [];

    if (file.existsSync()) {
      final String response = await file.readAsString();
      final List<dynamic> data = json.decode(response);
      grupos = data.map((json) => Grupo.fromJson(json)).toList();
    }

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final groupId = args['id'] as int; // Obter o ID do grupo
    final grupo = grupos.firstWhere((grupo) => grupo.id == groupId);

    if (!grupo.users.contains(user.email)) {
      grupo.users.add(user.email);
      final String jsonString =
          json.encode(grupos.map((grupo) => grupo.toJson()).toList());
      await file.writeAsString(jsonString);
    }

    Navigator.pushNamed(context, '/pessoas', arguments: {
      'grupoId':
          grupo.id, // Certifique-se de que esse valor é um int e não nulo
      'email': user.email,
    }); // Navega para a tela Membros
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buscar Membros"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 140, 188, 254),
              ),
              child: Text('Contas Compartilhadas'),
            ),
            ListTile(
              title: Text('Perfil'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/perfilPessoal',
                );
              },
            ),
            ListTile(
              title: Text('Pessoas'),
              onTap: () {
                Navigator.pushNamed(context, '/pessoas');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: [
              const Text(
                "Busca de Membros",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: buscaController,
                decoration: InputDecoration(
                  labelText: "E-mail",
                  hintText: "Ex.: mail@gmail.com",
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: searchMembers,
                child: Text('Buscar'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final user = searchResults[index];
                    return ListTile(
                      title: Text(user.name),
                      subtitle: Text(user.email),
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => addMemberToGroup(user),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
