class ScriptSQLite {
  // ===== COMANDOS DE CRIAÇÃO DE TABELAS =====
  
  // Tabelas principais (sem dependências)
  static const String _criarTabelaFabricante = '''
    CREATE TABLE fabricante (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaCategoriaMusica = '''
    CREATE TABLE categoria_musica (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      ativa INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaTipoManutencao = '''
    CREATE TABLE tipo_manutencao (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      ativa INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaArtistaBanda = '''
    CREATE TABLE artista_banda (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      descricao TEXT,
      link TEXT,
      foto TEXT,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const String _criarTabelaAluno = '''
    CREATE TABLE aluno (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      email TEXT NOT NULL,
      data_nascimento TEXT NOT NULL,
      genero TEXT NOT NULL,
      telefone TEXT NOT NULL,
      url_foto TEXT,
      instagram TEXT,
      facebook TEXT,
      tiktok TEXT,
      observacoes TEXT,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''';

  // Variável pública com todos os comandos de criação
  static const List<String> comandosCriarTabelas = [
    _criarTabelaFabricante,
    _criarTabelaCategoriaMusica,
    _criarTabelaTipoManutencao,
    _criarTabelaArtistaBanda,
    _criarTabelaAluno,
  ];

  // ===== COMANDOS DE INSERÇÃO =====
  
  // Inserções para Fabricante
  static const List<String> _insercoesFabricante = [
    "INSERT INTO fabricante (nome, ativo) VALUES ('Specialized', 1)",
    "INSERT INTO fabricante (nome, ativo) VALUES ('Trek', 1)",
    "INSERT INTO fabricante (nome, ativo) VALUES ('Giant', 1)",
    "INSERT INTO fabricante (nome, ativo) VALUES ('Cannondale', 1)",
    "INSERT INTO fabricante (nome, ativo) VALUES ('Scott', 1)",
  ];

  // Inserções para CategoriaMusica
  static const List<String> _insercoesCategoriaMusica = [
    "INSERT INTO categoria_musica (nome, ativa) VALUES ('Pop', 1)",
    "INSERT INTO categoria_musica (nome, ativa) VALUES ('Rock', 1)",
    "INSERT INTO categoria_musica (nome, ativa) VALUES ('Eletrônica', 1)",
    "INSERT INTO categoria_musica (nome, ativa) VALUES ('Hip Hop', 1)",
    "INSERT INTO categoria_musica (nome, ativa) VALUES ('Reggaeton', 1)",
    "INSERT INTO categoria_musica (nome, ativa) VALUES ('Funk', 1)",
    "INSERT INTO categoria_musica (nome, ativa) VALUES ('Sertanejo', 1)",
    "INSERT INTO categoria_musica (nome, ativa) VALUES ('MPB', 1)",
  ];

  // Inserções para TipoManutencao
  static const List<String> _insercoesTipoManutencao = [
    "INSERT INTO tipo_manutencao (nome, ativa) VALUES ('Pedal quebrado', 1)",
    "INSERT INTO tipo_manutencao (nome, ativa) VALUES ('Regulagem de altura', 1)",
    "INSERT INTO tipo_manutencao (nome, ativa) VALUES ('Pé-de-vela solto', 1)",
    "INSERT INTO tipo_manutencao (nome, ativa) VALUES ('Correia desgastada', 1)",
    "INSERT INTO tipo_manutencao (nome, ativa) VALUES ('Banco com problema', 1)",
    "INSERT INTO tipo_manutencao (nome, ativa) VALUES ('Monitor com defeito', 1)",
  ];

  // Inserções para ArtistaBanda
  static const List<String> _insercoesArtistaBanda = [
    "INSERT INTO artista_banda (nome, descricao, link, foto, ativo) VALUES ('The Weeknd', 'Artista canadense de R&B', 'https://theweeknd.com', 'https://example.com/theweeknd.jpg', 1)",
    "INSERT INTO artista_banda (nome, descricao, link, foto, ativo) VALUES ('Dua Lipa', 'Cantora britânica de pop', 'https://dualipa.com', 'https://example.com/dualipa.jpg', 1)",
    "INSERT INTO artista_banda (nome, descricao, link, foto, ativo) VALUES ('Imagine Dragons', 'Banda de rock alternativo', 'https://imaginedragonsmusic.com', 'https://example.com/imaginedragons.jpg', 1)",
    "INSERT INTO artista_banda (nome, descricao, link, foto, ativo) VALUES ('Calvin Harris', 'DJ e produtor escocês', 'https://calvinharris.com', 'https://example.com/calvinharris.jpg', 1)",
    "INSERT INTO artista_banda (nome, descricao, link, foto, ativo) VALUES ('Post Malone', 'Rapper e cantor americano', 'https://postmalone.com', 'https://example.com/postmalone.jpg', 1)",
  ];

  // Inserções para Aluno
  static const List<String> _insercoesAluno = [
    "INSERT INTO aluno (nome, email, data_nascimento, genero, telefone, url_foto, instagram, facebook, tiktok, observacoes, ativo) VALUES ('Ana Silva', 'ana.silva@email.com', '1990-05-15', 'feminino', '(11) 99999-1111', 'https://example.com/ana.jpg', 'https://instagram.com/ana.silva', 'https://facebook.com/ana.silva', 'https://tiktok.com/@ana.silva', 'Aluna dedicada', 1)",
    "INSERT INTO aluno (nome, email, data_nascimento, genero, telefone, url_foto, instagram, facebook, tiktok, observacoes, ativo) VALUES ('João Santos', 'joao.santos@email.com', '1985-08-22', 'masculino', '(11) 99999-2222', 'https://example.com/joao.jpg', 'https://instagram.com/joao.santos', 'https://facebook.com/joao.santos', 'https://tiktok.com/@joao.santos', 'Aluno iniciante', 1)",
    "INSERT INTO aluno (nome, email, data_nascimento, genero, telefone, url_foto, instagram, facebook, tiktok, observacoes, ativo) VALUES ('Maria Costa', 'maria.costa@email.com', '1992-12-10', 'feminino', '(11) 99999-3333', 'https://example.com/maria.jpg', 'https://instagram.com/maria.costa', 'https://facebook.com/maria.costa', 'https://tiktok.com/@maria.costa', 'Aluna avançada', 1)",
    "INSERT INTO aluno (nome, email, data_nascimento, genero, telefone, url_foto, instagram, facebook, tiktok, observacoes, ativo) VALUES ('Pedro Oliveira', 'pedro.oliveira@email.com', '1988-03-25', 'masculino', '(11) 99999-4444', 'https://example.com/pedro.jpg', 'https://instagram.com/pedro.oliveira', 'https://facebook.com/pedro.oliveira', 'https://tiktok.com/@pedro.oliveira', 'Aluno intermediário', 1)",
    "INSERT INTO aluno (nome, email, data_nascimento, genero, telefone, url_foto, instagram, facebook, tiktok, observacoes, ativo) VALUES ('Lucia Ferreira', 'lucia.ferreira@email.com', '1995-07-08', 'feminino', '(11) 99999-5555', 'https://example.com/lucia.jpg', 'https://instagram.com/lucia.ferreira', 'https://facebook.com/lucia.ferreira', 'https://tiktok.com/@lucia.ferreira', 'Aluna nova', 1)",
  ];

  // Variável pública com todas as inserções
  static const List<List<String>> comandosInsercoes = [
    _insercoesFabricante,
    _insercoesCategoriaMusica,
    _insercoesTipoManutencao,
    _insercoesArtistaBanda,
    _insercoesAluno,
  ];
} 