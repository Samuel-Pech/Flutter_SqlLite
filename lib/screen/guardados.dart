import 'package:flutter/material.dart';
import 'package:lista_tareas/components/navbar.dart';
import 'package:lista_tareas/models/tareas.dart';
import 'package:lista_tareas/screen/detalles_tarea.dart';
import 'package:lista_tareas/sqlite/sqllitedb.dart';

class GuardadosScreen extends StatefulWidget {
  const GuardadosScreen({Key? key}) : super(key: key);

  @override
  _GuardadosScreenState createState() => _GuardadosScreenState();
}

class _GuardadosScreenState extends State<GuardadosScreen> {
  List<Tarea> _tareasGuardadas = [];

  @override
  void initState() {
    super.initState();
    _cargarTareasGuardadas();
  }

  void _cargarTareasGuardadas() async {
    final db = await SQLLiteDB.instance;
    final tareas = await db.getTareas();
    setState(() {
      _tareasGuardadas = tareas.where((tarea) => tarea.guardada).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tareas Guardadas'),
          centerTitle: true,
          backgroundColor: Colors.teal[800],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _tareasGuardadas.isEmpty
              ? Center(
                  child: Text(
                    'No hay tareas guardadas.',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                )
              : ListView.separated(
                  itemCount: _tareasGuardadas.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final tarea = _tareasGuardadas[index];
                    return Card(
                      child: ListTile(
                        title: Text(tarea.titulo),
                        subtitle: Text(tarea.descripcion),
                        trailing: Icon(tarea.completada
                            ? Icons.check_circle
                            : Icons.check_circle_outline),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetallesTareaScreen(tarea: tarea),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
        bottomNavigationBar:
            const Navbar(), // Asegúrate de que Navbar no tenga problemas de navegación
      ),
    );
  }
}
