import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_video_aula.dart';
import 'package:sqflite/sqflite.dart';

class DAOVideoAula {
  Map<String, dynamic> _toMap(DTOVideoAula videoAula) {
    return {
      'nome': videoAula.nome,
      'link_video': videoAula.linkVideo,
      'ativo': videoAula.ativo ? 1 : 0, 
    };
  }

  DTOVideoAula _fromMap(Map<String, dynamic> map) {
    return DTOVideoAula(
      id: map['id'],
      nome: map['nome'],
      linkVideo: map['link_video'],
      ativo: map['ativo'] == 1, 
    );
  }

  Future<int> salvar(DTOVideoAula videoAula) async {
    Database db = await ConexaoSQLite.database;
    var videoAulaMap = _toMap(videoAula); 

    if (videoAula.id == null) {
      return await db.insert('video_aula', videoAulaMap);
    } else {
      return await db.update(
        'video_aula',
        videoAulaMap,
        where: 'id = ?',
        whereArgs: [videoAula.id],
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

  Future<List<DTOVideoAula>> listar() async {
    Database db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query('video_aula', orderBy: 'nome');

    return List.generate(maps.length, (i) {
      return _fromMap(maps[i]);
    });
  }
}
