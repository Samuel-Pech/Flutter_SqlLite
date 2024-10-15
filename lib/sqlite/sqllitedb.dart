import 'package:lista_tareas/models/tareas.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLLiteDB {
  static final SQLLiteDB instance = SQLLiteDB._init();
  static Database? _database;

  SQLLiteDB._init();

  Future<Database> get database async {
    // Si la base de datos ya está inicializada, retorna la instancia
    if (_database != null) return _database!;
    // Inicializa la base de datos
    _database = await _initDB('tareas.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // Obtiene la ruta de la base de datos
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    // Abre la base de datos
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    // Crea la tabla tareas con la nueva columna guardada
    await db.execute('''
      CREATE TABLE tareas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        fechaLimite TEXT NOT NULL,
        completada INTEGER NOT NULL,
        guardada INTEGER NOT NULL DEFAULT 0 
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Agrega la columna guardada a la tabla tareas si no existe
      await db.execute(
          'ALTER TABLE tareas ADD COLUMN guardada INTEGER NOT NULL DEFAULT 0');
    }
  }

  // Método para obtener todas las tareas
  Future<List<Tarea>> getTareas() async {
    final db = await instance.database;
    final result = await db.query('tareas');

    return result.map((json) => Tarea.fromMap(json)).toList();
  }

  // Método para insertar una nueva tarea
  Future<void> insertarTarea(Map<String, dynamic> tarea) async {
    final db = await instance.database;
    await db.insert('tareas', tarea);
  }

  // Método para actualizar una tarea existente
  Future<void> actualizarTarea(Tarea tarea) async {
    final db = await instance.database;
    await db.update(
      'tareas',
      tarea.toMap(),
      where: 'id = ?',
      whereArgs: [tarea.id],
    );
  }

  // Método para eliminar una tarea por ID
  Future<void> eliminarTarea(int id) async {
    final db = await instance.database;
    await db.delete(
      'tareas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  updateTarea(int? id, bool completada, bool bool) {}
}
