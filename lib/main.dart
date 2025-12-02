import 'screens/screens.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dragon Ball API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Pantalla inicial: login / registro
      initialRoute: 'logOrReg',
      routes: {
        '/': (context) => const HomeScreen(),
        'logOrReg': (context) => const LoginOrRegisterScreen(),
        'characters': (context) => const CharactersScreen(),
        'planets': (context) => const PlanetsScreen(),
      },
    );
  }
}
