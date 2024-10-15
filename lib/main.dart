import 'package:flutter/material.dart';
import 'package:lista_tareas/screen/home.dart';

void main() {
  runApp(const ListaTareasApp());
}

class ListaTareasApp extends StatelessWidget {
  const ListaTareasApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tareas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
