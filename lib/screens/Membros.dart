import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../models/BD.dart'; // Certifique-se de ajustar o caminho conforme necessário

class Membros extends StatefulWidget {
  const Membros({super.key});

  @override
  State<Membros> createState() => _MembrosState();
}

class _MembrosState extends State<Membros> {
  late Future<List<User>> _usersFuture;
  late Grupo _grupoSelecionado;

  @override
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      // Trate o caso onde os argumentos são nulos
      print("Erro: Argumentos não encontrados.");
      return;
    }

    final grupoId = args['grupoId'] as int?;
    if (grupoId == null) {
      // Trate o caso onde o ID do grupo é nulo
      print("Erro: ID do grupo não foi encontrado.");
      return;
    }

    _usersFuture = loadGroupAndUsers(grupoId);
  }

  Future<List<User>> loadGroupAndUsers(int grupoId) async {
    final directory = await getApplicationDocumentsDirectory();
    final gruposPath = '${directory.path}/grupos.json';
    final usuariosPath = '${directory.path}/usuarios.json';

    List<Grupo> grupos = [];
    if (await File(gruposPath).exists()) {
      final String response = await File(gruposPath).readAsString();
      final List<dynamic> data = json.decode(response);
      grupos = data.map((json) => Grupo.fromJson(json)).toList();
    }

    final grupo = grupos.firstWhere((g) => g.id == grupoId);
    _grupoSelecionado = grupo;

    List<User> users = [];
    if (await File(usuariosPath).exists()) {
      final String response = await File(usuariosPath).readAsString();
      final List<dynamic> data = json.decode(response);
      final allUsers = data.map((json) => User.fromJson(json)).toList();
      users =
          allUsers.where((user) => grupo.users.contains(user.email)).toList();
    }

    return users;
  }

  Future<void> _removeUserFromGroup(String userEmail) async {
    final directory = await getApplicationDocumentsDirectory();
    final gruposPath = '${directory.path}/grupos.json';
    final usuariosPath = '${directory.path}/usuarios.json';

    // Remove o usuário do grupo
    List<Grupo> grupos = [];
    if (await File(gruposPath).exists()) {
      final String response = await File(gruposPath).readAsString();
      final List<dynamic> data = json.decode(response);
      grupos = data.map((json) => Grupo.fromJson(json)).toList();
    }

    final grupoIndex = grupos.indexWhere((g) => g.id == _grupoSelecionado.id);
    if (grupoIndex != -1) {
      _grupoSelecionado.users.remove(userEmail);
      grupos[grupoIndex] = _grupoSelecionado;

      final updatedGruposJson =
          json.encode(grupos.map((g) => g.toJson()).toList());
      await File(gruposPath).writeAsString(updatedGruposJson);
    }

    // Atualiza a lista de usuários
    setState(() {
      _usersFuture = loadGroupAndUsers(_grupoSelecionado.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final email = args['email'];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Membros"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/BuscaMembro',
                  arguments: {"id": _grupoSelecionado.id, "email": email});
            },
          ),
        ],
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
                Navigator.pushNamed(context, '/perfilPessoal',
                    arguments: email);
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
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum membro encontrado.'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      _showRemoveConfirmationDialog(user.email);
                    },
                  ),
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/perfil',
                    arguments: user, // Passe o objeto User como argumento
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showRemoveConfirmationDialog(String userEmail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Remoção'),
          content: Text('Deseja remover este membro do grupo?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _removeUserFromGroup(userEmail);
                Navigator.of(context).pop();
              },
              child: Text('Remover'),
            ),
          ],
        );
      },
    );
  }
}
