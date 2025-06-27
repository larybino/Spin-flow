import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_musica.dart';
import 'package:sqflite/sqflite.dart';

class DAOMusica {
  Map<String, dynamic> _toMap(DTOMusica musica) {
    return {
      'nome': musica.nome,
      'artista': musica.artista,
      'categorias': musica.categorias, 
      'linksVideoAulas': musica.linksVideoAula,
      'descricao': musica.descricao,
    };
  }

  DTOMusica _fromMap(Map<String, dynamic> map) {
    return DTOMusica(
      id: map['id'],
      nome: map['nome'],
      artista: map['artista'],
      categorias: map['categorias'],
      linksVideoAula: map['linksVideoAula'],
      descricao: map['descricao'],
    );
  }

  Future<int> salvar(DTOMusica musica) async {
    Database db = await ConexaoSQLite.database;
    var musicMap = _toMap(musica); 

    if (musica.id == null) {
      return await db.insert('video_aula', musicMap);
    } else {
      return await db.update(
        'video_aula',
        musicMap,
        where: 'id = ?',
        whereArgs: [musica.id],
      );
    }
  }

  Future<int> excluir(int id) async {
    Database db = await ConexaoSQLite.database;
    return await db.delete(
      'video_aula',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<DTOMusica>> listar() async {
  Database db = await ConexaoSQLite.database;
  final List<Map<String, dynamic>> maps = await db.query('musica', orderBy: 'nome');

  return List.generate(maps.length, (i) {
    return _fromMap(maps[i]);
  });
}
}
