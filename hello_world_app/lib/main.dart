import 'package:flutter/material.dart';
import 'package:hello_world_app/presentation/screens/counter/counter_functions_screen.dart';
import 'package:hello_world_app/presentation/screens/counter/counter_screen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 240, 236, 43),
        fontFamily: 'Minecraft', // <-- ¡Agregando esta línea se aplica la fuente a toda la app!
      ),
      home: const CounterFunctionsScreen()
    );
  }
}