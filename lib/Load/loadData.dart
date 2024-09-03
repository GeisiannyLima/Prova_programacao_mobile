import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:contas_compartilhadas/models/BD.dart';

Future<List<User>> loadUsers() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/usuarios.json';
  final file = File(path);

  if (file.existsSync()) {
    final String response = await file.readAsString();
    final List<dynamic> data = json.decode(response);
    return data.map((json) => User.fromJson(json)).toList();
  } else {
    // Retorna uma lista vazia se o arquivo não existir
    return [];
  }
}

Future<List<Grupo>> loadGrupos() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/grupos.json';
  final file = File(path);

  if (file.existsSync()) {
    final String response = await file.readAsString();
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Grupo.fromJson(json)).toList();
  } else {
    // Retorna uma lista vazia se o arquivo não existir
    return [];
  }
}

Future<List<Expense>> loadExpenses() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/despesas.json';
  final file = File(path);

  if (file.existsSync()) {
    final String response = await file.readAsString();
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Expense.fromJson(json)).toList();
  } else {
    // Retorna uma lista vazia se o arquivo não existir
    return [];
  }
}
