import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_fabricante.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_categoria_musica.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_tipo_manutencao.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_artista_banda.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_aluno.dart';
import 'package:spin_flow/dto/dto_fabricante.dart';
import 'package:spin_flow/dto/dto_categoria_musica.dart';
import 'package:spin_flow/dto/dto_tipo_manutencao.dart';
import 'package:spin_flow/dto/dto_artista_banda.dart';
import 'package:spin_flow/dto/dto_aluno.dart';

class ExemploUsoSQLite {
  
  // Exemplo de uso dos DAOs
  static Future<void> exemploCompleto() async {
    try {
      // 1. Inicializar conexão
      final db = await ConexaoSQLite.database;
      print('✅ Banco conectado com sucesso!');
      
      // 2. Testar Fabricante
      await _testarFabricante();
      
      // 3. Testar CategoriaMusica
      await _testarCategoriaMusica();
      
      // 4. Testar TipoManutencao
      await _testarTipoManutencao();
      
      // 5. Testar ArtistaBanda
      await _testarArtistaBanda();
      
      // 6. Testar Aluno
      await _testarAluno();
      
    } catch (e) {
      print('❌ Erro: $e');
    }
  }
  
  static Future<void> _testarFabricante() async {
    print('\n🏭 Testando Fabricante...');
    
    // Buscar todos
    final fabricantes = await DAOFabricante.buscarTodos();
    print('📋 Fabricantes encontrados: ${fabricantes.length}');
    
    // Criar novo
    final novoFabricante = DTOFabricante(
      nome: 'Novo Fabricante Teste',
      ativo: true,
    );
    
    final id = await DAOFabricante.salvar(novoFabricante);
    print('✅ Fabricante criado com ID: $id');
    
    // Buscar por ID
    final fabricante = await DAOFabricante.buscarPorId(id);
    print('🔍 Fabricante encontrado: ${fabricante?.nome}');
  }
  
  static Future<void> _testarCategoriaMusica() async {
    print('\n🎵 Testando CategoriaMusica...');
    
    // Buscar todos
    final categorias = await DAOCategoriaMusica.buscarTodos();
    print('📋 Categorias encontradas: ${categorias.length}');
    
    // Criar nova
    final novaCategoria = DTOCategoriaMusica(
      nome: 'Nova Categoria Teste',
      ativa: true,
    );
    
    final id = await DAOCategoriaMusica.salvar(novaCategoria);
    print('✅ Categoria criada com ID: $id');
  }
  
  static Future<void> _testarTipoManutencao() async {
    print('\n🔧 Testando TipoManutencao...');
    
    // Buscar todos
    final tipos = await DAOTipoManutencao.buscarTodos();
    print('📋 Tipos encontrados: ${tipos.length}');
    
    // Criar novo
    final novoTipo = DTOTipoManutencao(
      nome: 'Novo Tipo Teste',
      ativa: true,
    );
    
    final id = await DAOTipoManutencao.salvar(novoTipo);
    print('✅ Tipo criado com ID: $id');
  }
  
  static Future<void> _testarArtistaBanda() async {
    print('\n🎤 Testando ArtistaBanda...');
    
    // Buscar todos
    final artistas = await DAOArtistaBanda.buscarTodos();
    print('📋 Artistas encontrados: ${artistas.length}');
    
    // Criar novo
    final novoArtista = DTOArtistaBanda(
      nome: 'Novo Artista Teste',
      descricao: 'Descrição do artista teste',
      link: 'https://exemplo.com',
      foto: 'https://exemplo.com/foto.jpg',
      ativo: true,
    );
    
    final id = await DAOArtistaBanda.salvar(novoArtista);
    print('✅ Artista criado com ID: $id');
  }
  
  static Future<void> _testarAluno() async {
    print('\n👤 Testando Aluno...');
    
    // Buscar todos
    final alunos = await DAOAluno.buscarTodos();
    print('📋 Alunos encontrados: ${alunos.length}');
    
    // Criar novo
    final novoAluno = DTOAluno(
      nome: 'Novo Aluno Teste',
      email: 'novo.aluno@teste.com',
      dataNascimento: DateTime(1990, 1, 1),
      genero: 'masculino',
      telefone: '(11) 99999-9999',
      urlFoto: 'https://exemplo.com/foto.jpg',
      instagram: 'https://instagram.com/novo.aluno',
      facebook: 'https://facebook.com/novo.aluno',
      tiktok: 'https://tiktok.com/@novo.aluno',
      observacoes: 'Aluno teste',
      ativo: true,
    );
    
    final id = await DAOAluno.salvar(novoAluno);
    print('✅ Aluno criado com ID: $id');
  }
} 