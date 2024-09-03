import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/BD.dart';

class CadastroGrupos extends StatefulWidget {
  const CadastroGrupos({super.key});

  @override
  State<CadastroGrupos> createState() => _CadastroGruposState();
}

class _CadastroGruposState extends State<CadastroGrupos> {
  late final TextEditingController nameController;
  final emailController = TextEditingController();
  final List<String> userList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final email = ModalRoute.of(context)?.settings.arguments as String?;
    emailController.text = email ?? '';
    nameController = TextEditingController();
    if (email != null) {
      userList.add(email);
    }
  }

  Future<void> addGrupo(Grupo newGrupo) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/grupos.json';
    final file = File(path);

    List<Grupo> grupos = [];

    if (file.existsSync()) {
      final String response = await file.readAsString();
      final List<dynamic> data = json.decode(response);
      grupos = data.map((json) => Grupo.fromJson(json)).toList();
    }

    grupos.add(newGrupo);

    final String jsonString =
        json.encode(grupos.map((grupo) => grupo.toJson()).toList());
    await file.writeAsString(jsonString);
  }

  void addUser() {
    final email = emailController.text;
    if (email.isNotEmpty && !userList.contains(email)) {
      setState(() {
        userList.add(email);
        emailController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de Grupos"),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "E-mail do Usuário",
                  hintText: "Ex: mail@gmail.com",
                ),
              ),
              ElevatedButton(
                onPressed: addUser,
                child: Text("Adicionar Usuário"),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Nome do Grupo",
                  hintText: "Ex.: Grupo A",
                ),
              ),
              Text("Usuários no Grupo: ${userList.join(', ')}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Voltar"),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final name = nameController.text;
                      final id = Uuid().v4();
                      final newGrupo = Grupo(
                        id: id.hashCode, // ID gerado usando hashCode do UUID
                        name: name,
                        users: userList,
                      );

                      addGrupo(newGrupo).then((_) {
                        Navigator.pop(context);
                      }).catchError((error) {
                        // Tratar erro ao salvar
                        print("Erro ao salvar grupo: $error");
                      });
                    },
                    child: Text("Cadastrar"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
