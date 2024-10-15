class Tarea {
  final int? id;
  final String titulo;
  final String descripcion;
  final DateTime fechaLimite;
  final bool completada;
  final bool guardada;

  Tarea({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.fechaLimite,
    this.completada = false,
    this.guardada = false,
  })  : assert(titulo.isNotEmpty, 'El título no puede estar vacío'),
        assert(descripcion.isNotEmpty, 'La descripción no puede estar vacía'),
        assert(fechaLimite.isAfter(DateTime.now()),
            'La fecha límite debe ser en el futuro');

  // Método copyWith para crear una nueva instancia con valores actualizados
  Tarea copyWith({
    int? id,
    String? titulo,
    String? descripcion,
    DateTime? fechaLimite,
    bool? completada,
    bool? guardada,
  }) {
    return Tarea(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      fechaLimite: fechaLimite ?? this.fechaLimite,
      completada: completada ?? this.completada,
      guardada: guardada ?? this.guardada,
    );
  }

  // Convierte la tarea a un mapa para almacenar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'fechaLimite': fechaLimite.toIso8601String(),
      'completada': completada ? 1 : 0,
      'guardada': guardada ? 1 : 0,
    };
  }

  // Crea una tarea desde un mapa, útil para leer de la base de datos
  factory Tarea.fromMap(Map<String, dynamic> map) {
    return Tarea(
      id: map['id'],
      titulo: map['titulo'],
      descripcion: map['descripcion'],
      fechaLimite: DateTime.parse(map['fechaLimite']),
      completada: map['completada'] == 1,
      guardada: map['guardada'] == 1,
    );
  }

  @override
  String toString() {
    return 'Tarea{id: $id, titulo: $titulo, descripcion: $descripcion, fechaLimite: $fechaLimite, completada: $completada, guardada: $guardada}';
  }
}
