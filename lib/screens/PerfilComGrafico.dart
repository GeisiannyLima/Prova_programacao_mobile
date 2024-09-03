import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/BD.dart'; // Certifique-se de ajustar o caminho conforme necessário
import 'package:path_provider/path_provider.dart';

class GraficoPage extends StatefulWidget {
  @override
  _GraficoPageState createState() => _GraficoPageState();
}

class _GraficoPageState extends State<GraficoPage> {
  late Future<User> _userFuture;
  String currentMonth = DateFormat.MMMM('pt_BR').format(DateTime.now());

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
            } else if (!snapshot.hasData) {
              return Text('Usuário não encontrado');
            } else {
              final user = snapshot.data!;
              return Text('Finanças de ${user.name}');
            }
          },
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
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
                  // Avatar e Nome
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
                  SizedBox(height: 16),
                  // Seletor de Mês
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Selecionar', style: TextStyle(fontSize: 16)),
                      DropdownButton<String>(
                        items: <String>[
                          'Janeiro',
                          'Fevereiro',
                          'Março',
                          'Abril',
                          'Maio',
                          'Junho',
                          'Julho',
                          'Agosto',
                          'Setembro',
                          'Outubro',
                          'Novembro',
                          'Dezembro'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {},
                        hint: Text(currentMonth), // Exibe o mês atual como hint
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Gráfico de Barras
                  Container(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        barGroups: [
                          BarChartGroupData(x: 0, barRods: [
                            BarChartRodData(
                                toY: 10400.75, color: Colors.green, width: 30),
                          ]),
                          BarChartGroupData(x: 1, barRods: [
                            BarChartRodData(
                                toY: 5943.50, color: Colors.red, width: 30),
                          ]),
                        ],
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 0:
                                    return Text('Receitas');
                                  case 1:
                                    return Text('Despesas');
                                  default:
                                    return SizedBox(); // Retorna vazio para outros valores
                                }
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: false), // Remover títulos do topo
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barTouchData: BarTouchData(enabled: false),
                        gridData: FlGridData(show: false),
                        alignment: BarChartAlignment.spaceAround,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  // Exibir os valores máximos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text('10.400,75',
                          style: TextStyle(fontSize: 16, color: Colors.green)),
                      Text('5.943,50',
                          style: TextStyle(fontSize: 16, color: Colors.red)),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Saldo
                  Center(
                    child: Text(
                      '4.457,25',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Text('Saldo', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
