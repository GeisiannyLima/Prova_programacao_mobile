import 'package:contas_compartilhadas/screens/BuscaMembro.dart';
import 'package:contas_compartilhadas/screens/CadastroDispesa.dart';
import 'package:contas_compartilhadas/screens/CadastroGrupos.dart';
import 'package:contas_compartilhadas/screens/Grupos.dart';
import 'package:contas_compartilhadas/screens/Membros.dart';
import 'package:contas_compartilhadas/screens/PerfilComGrafico.dart';
import 'package:contas_compartilhadas/screens/PerfilPessoa.dart';
import 'package:contas_compartilhadas/screens/PerfilPessoal.dart';
import 'package:contas_compartilhadas/screens/cadastro_usuarios.dart';
import 'package:contas_compartilhadas/screens/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [
        Locale('pt', 'BR'), // Brazilian Portuguese
        // Add other locales as needed
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => LoginPage(title: "Login"),
        '/home': (context) => Grupos(),
        '/pessoas': (context) => Membros(),
        '/grafico': (context) => GraficoPage(),
        '/perfil': (context) => PerfilPessoa(),
        '/perfilPessoal': (context) => PerfilPessoal(),
        '/cadastroDispesa': (context) => CadastroDispesa(),
        '/cadastroUsuarios': (context) => CadastroUsuarios(),
        '/cadastroGrupo': (context) => CadastroGrupos(),
        '/BuscaMembro': (context) => BuscaMembro(),
      },
      //home: const LoginPage(title: 'Contas Compartilhadas'),
    );
  }
}
