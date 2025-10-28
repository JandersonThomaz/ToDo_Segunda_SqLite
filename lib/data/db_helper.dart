import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  final database = openDatabase(
    join(await getDatabasesPath(), "tarefas.db"),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE tarefas(id INTEGER PRIMARY KEY, nome TEXT, descricao TEXT, finalizada INTEGER)',
      );
    },
    version: 1,
  );
  
  return database;
}
