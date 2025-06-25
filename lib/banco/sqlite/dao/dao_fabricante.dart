import 'package:sqflite/sqflite.dart';
import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_fabricante.dart';

class DAOFabricante {
  static const String _tabela = 'fabricante';

  // Salvar (inserir ou atualizar)
  static Future<int> salvar(DTOFabricante fabricante) async {
    final db = await ConexaoSQLite.database;
    
    if (fabricante.id != null) {
      // Atualizar
      return await db.update(
        _tabela,
        {
          'nome': fabricante.nome,
          'ativo': fabricante.ativo ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [fabricante.id],
      );
    } else {
      // Inserir
      return await db.insert(
        _tabela,
        {
          'nome': fabricante.nome,
          'ativo': fabricante.ativo ? 1 : 0,
        },
      );
    }
  }

  // Buscar todos
  static Future<List<DTOFabricante>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(_tabela);
    
    return List.generate(maps.length, (i) {
      return DTOFabricante(
        id: maps[i]['id'],
        nome: maps[i]['nome'],
        ativo: maps[i]['ativo'] == 1,
      );
    });
  }

  // Buscar por ID
  static Future<DTOFabricante?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return DTOFabricante(
        id: maps[0]['id'],
        nome: maps[0]['nome'],
        ativo: maps[0]['ativo'] == 1,
      );
    }
    return null;
  }

  // Excluir
  static Future<int> excluir(int id) async {
    final db = await ConexaoSQLite.database;
    return await db.delete(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
} 