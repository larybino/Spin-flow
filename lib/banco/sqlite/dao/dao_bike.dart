import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_bike.dart';
import 'package:spin_flow/dto/dto_fabricante.dart';
import 'package:sqflite/sqflite.dart';

class DAOBike {
  Future<Database> get db => ConexaoSQLite.database;

  Map<String, dynamic> _toMap(DTOBike bike) {
    return {
      'id': bike.id,
      'nome': bike.nome,
      'numero_serie': bike.numeroSerie,
      'data_cadastro': bike.dataCadastro.toIso8601String(),
      'ativa': bike.ativa ? 1 : 0,
      'id_fabricante': bike.fabricante.id,
    };
  }

  Future<int> salvar(DTOBike bike) async {
    var database = await db;
    Map<String, dynamic> bikeMap = _toMap(bike);

    if (bike.id == null) {
      bikeMap.remove('id'); 
      return await database.insert('bike', bikeMap);
    } else {
      return await database.update('bike', bikeMap, where: 'id = ?', whereArgs: [bike.id]);
    }
  }

  Future<int> excluir(int id) async {
    var database = await db;
    return await database.delete('bike', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<DTOBike>> listar() async {
    var database = await db;
    final List<Map<String, dynamic>> maps = await database.rawQuery('''
      SELECT 
        B.id, 
        B.nome, 
        B.numero_serie, 
        B.data_cadastro, 
        B.ativa,
        F.id as id_fabricante, 
        F.nome as nome_fabricante
      FROM bike B
      INNER JOIN fabricante F ON B.id_fabricante = F.id
      ORDER BY B.nome
    ''');

    return List.generate(maps.length, (i) {
      return _fromMap(maps[i]);
    });
  }

  DTOBike _fromMap(Map<String, dynamic> map) {
    return DTOBike(
      id: map['id'],
      nome: map['nome'],
      numeroSerie: map['numero_serie'],
      dataCadastro: DateTime.parse(map['data_cadastro']),
      ativa: map['ativa'] == 1,
      fabricante: DTOFabricante(
        id: map['id_fabricante'],
        nome: map['nome_fabricante'],
      ),
    );
  }
}
