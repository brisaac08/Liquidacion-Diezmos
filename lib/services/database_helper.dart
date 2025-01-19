import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:calculadora_de_diezmos/models/liquidacion.dart';

class DatabaseHelper {
  static final _databaseName = "liquidador.db";
  static final _databaseVersion = 1;

  static final table = 'liquidacion';

  static final columnId = 'id';
  static final columnTotal = 'total';
  static final columnPorcentaje21 = 'porcentaje21';
  static final columnPorcentaje8 = 'porcentaje8';
  static final columnPorcentaje7 = 'porcentaje7';
  static final columnRestante = 'restante';
  static final columnFecha = 'fecha';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion,
        onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE $table (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnTotal REAL NOT NULL,
          $columnPorcentaje21 REAL NOT NULL,
          $columnPorcentaje8 REAL NOT NULL,
          $columnPorcentaje7 REAL NOT NULL,
          $columnRestante REAL NOT NULL,
          $columnFecha TEXT NOT NULL
        )
      ''');
    });
  }

  Future<int> insertLiquidacion(Liquidacion liquidacion) async {
    final db = await database;
    return await db.insert(table, liquidacion.toMap());
  }
}
