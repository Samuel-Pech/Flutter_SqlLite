import 'package:flutter/material.dart';
import 'package:lista_tareas/models/tareas.dart';
import 'package:intl/intl.dart';

class DetallesTareaScreen extends StatefulWidget {
  final Tarea tarea;

  const DetallesTareaScreen({Key? key, required this.tarea}) : super(key: key);

  @override
  _DetallesTareaScreenState createState() => _DetallesTareaScreenState();
}

class _DetallesTareaScreenState extends State<DetallesTareaScreen> {
  late bool _completada;

  @override
  void initState() {
    super.initState();
    _completada = widget.tarea.completada;
  }

  void _actualizarEstado(bool? value) {
    setState(() {
      _completada = value!;
      // Aquí podrías llamar a un método para actualizar la tarea en la base de datos
      // ejemplo: await db.updateTarea(widget.tarea.id, _completada);
    });
  }

  void _guardarEnApartado() {
    // Aquí podrías agregar la lógica para guardar la tarea en un apartado
    // Ejemplo: await db.saveTaskToSection(widget.tarea.id, _completada);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Tarea guardada en el apartado exitosamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Tarea'),
        centerTitle: true,
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.tarea.titulo,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.teal),
            ),
            const SizedBox(height: 8),
            Text(
              'Descripción:',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(widget.tarea.descripcion),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Fecha Límite:',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              DateFormat('dd/MM/yyyy – kk:mm').format(widget.tarea.fechaLimite),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Estado:',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text('¿Completada?'),
              value: _completada,
              activeColor: Colors.green,
              onChanged: _actualizarEstado,
              secondary: Icon(
                _completada ? Icons.check_circle : Icons.check_circle_outline,
                color: _completada ? Colors.green : Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _guardarEnApartado,
                child: const Text(
                  'Guardar Tarea',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[800],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
