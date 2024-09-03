import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../Load/loadData.dart';
import '../models/BD.dart'; // Ajuste o caminho conforme necessário

class Grupos extends StatefulWidget {
  const Grupos({super.key});

  @override
  _GruposState createState() => _GruposState();
}

class _GruposState extends State<Grupos> {
  late Future<List<Grupo>> _gruposFuture;
  late String _email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _email = ModalRoute.of(context)!.settings.arguments as String;
    _gruposFuture = loadGruposForUser(_email);
  }

  Future<List<Grupo>> loadGruposForUser(String email) async {
    final directory = await getApplicationDocumentsDirectory();
    final gruposPath = '${directory.path}/grupos.json';

    List<Grupo> grupos = [];
    if (await File(gruposPath).exists()) {
      final String response = await File(gruposPath).readAsString();
      final List<dynamic> data = json.decode(response);
      grupos = data.map((json) => Grupo.fromJson(json)).toList();
    }

    // Filtra os grupos para incluir apenas aqueles que o usuário faz parte
    return grupos.where((grupo) => grupo.users.contains(email)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grupos"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/cadastroGrupo', arguments: _email);
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
                    arguments: _email);
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
      body: FutureBuilder<List<Grupo>>(
        future: _gruposFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum grupo cadastrado'));
          } else {
            final List<Grupo> grupos = snapshot.data!;
            return ListView.builder(
              itemCount: grupos.length,
              itemBuilder: (context, index) {
                final grupo = grupos[index];
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/pessoas',
                      arguments: {
                        "grupoId": grupo.id,
                        "email": _email
                      }, // Envia o ID do grupo e o email do usuário
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 140, 188, 254),
                      border: Border.all(
                        color: Colors.black,
                        width: 0.2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.group,
                          size: 40,
                          color: Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                grupo.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "${grupo.users.length} membros",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
