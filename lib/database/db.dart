import 'package:sqlite3/sqlite3.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  late final Database db;

  DatabaseService._internal() {
    db = sqlite3.open('filmes.db');
    _criarTabela();
  }

  void _criarTabela() {
    db.execute('''
      CREATE TABLE IF NOT EXISTS filmes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        genero TEXT NOT NULL,
        ano INTEGER NOT NULL
      )
    ''');
  }

  int inserirFilme(String titulo, String genero, int ano) {
    final stmt = db.prepare(
      'INSERT INTO filmes (titulo, genero, ano) VALUES (?, ?, ?)',
    );
    stmt.execute([titulo, genero, ano]);
    stmt.dispose();

    final result = db.select('SELECT last_insert_rowid() AS id');
    return result.first['id'] as int;
  }

  List<Map<String, Object?>> listarFilmes() {
    final result = db.select('SELECT * FROM filmes ORDER BY id');
    return result.map((row) => row).toList();
  }

  Map<String, Object?>? buscarFilmePorId(int id) {
    final result = db.select('SELECT * FROM filmes WHERE id = ?', [id]);
    if (result.isEmpty) return null;
    return result.first;
  }

  bool atualizarFilme(int id, String titulo, String genero, int ano) {
    db.execute(
      'UPDATE filmes SET titulo = ?, genero = ?, ano = ? WHERE id = ?',
      [titulo, genero, ano, id],
    );

    final result = db.select('SELECT changes() AS total');
    return (result.first['total'] as int) > 0;
  }

  bool deletarFilme(int id) {
    db.execute('DELETE FROM filmes WHERE id = ?', [id]);

    final result = db.select('SELECT changes() AS total');
    return (result.first['total'] as int) > 0;
  }
}