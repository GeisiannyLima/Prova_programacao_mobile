import 'package:contas_compartilhadas/tools/input/main.dart';
import 'package:contas_compartilhadas/tools/inputData/main.dart';

import 'package:flutter/material.dart';

class CadastroDispesa extends StatefulWidget {
  const CadastroDispesa({super.key});

  @override
  State<CadastroDispesa> createState() => _CadastroDispesaState();
}

class _CadastroDispesaState extends State<CadastroDispesa> {
  final nomeController = TextEditingController();
  final categoriaController = TextEditingController();
  final valorController = TextEditingController();
  final dataController = TextEditingController();
  final List<String> categorias = ['Conta Fixa', 'Conta Variável'];
  String categoriaSelecionada = 'Conta Fixa';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar Despesa"),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Cadastrar Despesa",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              inputWidget(
                  nomeController, context, "Nome", "Ex: Restaurante", false),
              DropdownButtonFormField(
                value: categoriaSelecionada,
                items: categorias.map((String item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Selecione a categoria',
                ),
                onChanged: (String? value) {},
              ),
              inputWidget(nomeController, context, "Valor", "Ex: 20,24", false),
              Padding(padding: EdgeInsets.only(top: 20)),
              DateInputField(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Voltar"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
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
