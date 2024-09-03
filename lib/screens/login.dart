import 'dart:ffi';

import 'package:contas_compartilhadas/Load/loadData.dart';
import 'package:contas_compartilhadas/models/BD.dart';
import 'package:contas_compartilhadas/tools/input/main.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = loadUsers();
  }

  Future<void> _login() async {
    final email = emailController.text;
    final password = passwordController.text;

    final List<User> users = await _usersFuture;

    bool validateUser(String email, String password) {
      for (var user in users) {
        if (user.email == email && user.password == password) {
          return true;
        }
      }
      return false;
    }

    if (validateUser(email, password)) {
      Navigator.pushNamed(context, '/home', arguments: email);
    } else {
      // Mostrar mensagem de erro
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro de Login'),
            content: Text('Email ou senha incorretos.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  // Passe argumento de email para a próxima tela

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Login",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              inputWidget(emailController, context, "E-mail",
                  "Ex.: mail@gmail.com", false),
              inputWidget(passwordController, context, "Password", '', true),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Entrar'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Esqueceu sua senha?'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/cadastroUsuarios');
                },
                child: const Text('Cadastre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
