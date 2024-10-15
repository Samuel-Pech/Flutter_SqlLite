import 'package:flutter/material.dart';
import 'package:lista_tareas/models/tareas.dart';
import 'package:lista_tareas/sqlite/sqllitedb.dart';

class CrearTareaScreen extends StatefulWidget {
  final Function() onTareaAgregada;
  const CrearTareaScreen({Key? key, required this.onTareaAgregada})
      : super(key: key);

  @override
  _CrearTareaScreenState createState() => _CrearTareaScreenState();
}

class _CrearTareaScreenState extends State<CrearTareaScreen> {
  final SQLLiteDB _dbHelper = SQLLiteDB.instance;
  final _formKey = GlobalKey<FormState>();

  String _titulo = '';
  String _descripcion = '';
  DateTime? _fechaLimite;
  bool _completada = false;
  bool _isLoading = false;

  Future<void> _guardarTarea() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Verifica que la fecha límite no sea nula
      if (_fechaLimite != null) {
        setState(() {
          _isLoading = true;
        });

        final nuevaTarea = Tarea(
          titulo: _titulo,
          descripcion: _descripcion,
          fechaLimite: _fechaLimite!,
          completada: _completada,
        );

        await _dbHelper.insertarTarea(nuevaTarea.toMap());

        setState(() {
          _isLoading = false;
        });

        widget.onTareaAgregada();
        Navigator.pop(context);

        // Mensaje de confirmación
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarea guardada con éxito.')),
        );
      } else {
        // Manejar el caso donde la fecha no es válida
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Por favor, selecciona una fecha válida.')),
        );
      }
    }
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaLimite ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _fechaLimite)
      setState(() {
        _fechaLimite = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nueva Tarea'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Título',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un título.';
                  }
                  return null;
                },
                onSaved: (value) => _titulo = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.description),
                ),
                onSaved: (value) => _descripcion = value!,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _seleccionarFecha(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Fecha Límite',
                      hintText: _fechaLimite != null
                          ? '${_fechaLimite!.toLocal()}'.split(' ')[0]
                          : 'Selecciona una fecha',
                      prefixIcon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _guardarTarea,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Guardar Tarea'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
