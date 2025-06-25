import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto_artista_banda.dart';
import 'package:spin_flow/dto/dto_categoria_musica.dart';
import 'package:spin_flow/dto/dto_musica.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/campos/selecao_multipla/campo_multi_selecao.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_opcoes.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_url.dart';
import 'package:spin_flow/banco/mock/mock_artistas_bandas.dart';
import 'package:spin_flow/banco/mock/mock_categorias_musica.dart';

class FormMusica extends StatefulWidget {
  const FormMusica({super.key});

  @override
  State<FormMusica> createState() => _FormMusicaState();
}

class _FormMusicaState extends State<FormMusica> {
  final _formKey = GlobalKey<FormState>();

  // Campos do formulário
  String? _nome;
  DTOArtistaBanda? _artistaSelecionado;
  final List<DTOCategoriaMusica> _categoriasSelecionadas = [];
  final List<Map<String, String?>> _links = [];
  String? _descricao;

  final List<DTOArtistaBanda> _artistasMock = mockArtistasBandas;
  final List<DTOCategoriaMusica> _categoriasMock = mockCategoriasMusica;

  void _adicionarLink() {
    setState(() {
      _links.add({
        'url': null,
        'descricao': null,
      });
    });
  }

  void _removerLink(int index) {
    setState(() {
      _links.removeAt(index);
    });
  }

  void _atualizarLink(int index, String campo, String? valor) {
    setState(() {
      _links[index][campo] = valor;
    });
  }

  void _limparFormulario() {
    setState(() {
      _nome = null;
      _artistaSelecionado = null;
      _categoriasSelecionadas.clear();
      _links.clear();
      _descricao = null;
    });
    _formKey.currentState?.reset();
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      if (_artistaSelecionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecione o artista/banda')),
        );
        return;
      }
      if (_categoriasSelecionadas.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecione pelo menos uma categoria')),
        );
        return;
      }

      final links = _links
          .where((link) => link['url'] != null && link['url']!.isNotEmpty)
          .map((link) => DTOLinkVideoAula(
                url: link['url']!,
                descricao: link['descricao'] ?? '',
              ))
          .toList();

      // Criar DTO
      final dto = DTOMusica(
        id: 0,
        nome: _nome ?? '',
        artista: _artistaSelecionado!,
        categorias: List.from(_categoriasSelecionadas),
        linksVideoAula: links,
        descricao: _descricao,
      );

      // Mostrar dados em dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Música Criada'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nome: ${dto.nome}'),
                Text('Artista: ${dto.artista.nome}'),
                Text('Descrição: ${dto.descricao ?? 'Não informado'}'),
                const SizedBox(height: 8),
                Text('Categorias (${dto.categorias.length}):', style: const TextStyle(fontWeight: FontWeight.bold)),
                ...dto.categorias.map((cat) => 
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 2),
                    child: Text('• ${cat.nome}'),
                  ),
                ),
                if (dto.linksVideoAula.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Links de Vídeo Aula (${dto.linksVideoAula.length}):', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ...dto.linksVideoAula.map((link) => 
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 2),
                      child: Text('• ${link.descricao}: ${link.url}'),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        ),
      );

      // SnackBar de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Música "${dto.nome}" salva com sucesso!')),
      );

      // Limpar formulário
      _limparFormulario();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Música'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Salvar',
            onPressed: _salvar,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CampoTexto(
                rotulo: 'Nome da Música',
                dica: 'Nome da música',
                eObrigatorio: true,
                onChanged: (value) => _nome = value,
              ),
              const SizedBox(height: 16),
              CampoOpcoes<DTOArtistaBanda>(
                opcoes: _artistasMock,
                valorSelecionado: _artistaSelecionado,
                rotulo: 'Artista/Banda',
                textoPadrao: 'Selecione o artista/banda',
                eObrigatorio: true,
                rotaCadastro: Rotas.cadastroArtistaBanda,
                onChanged: (artista) {
                  setState(() {
                    _artistaSelecionado = artista;
                  });
                },
              ),
              const SizedBox(height: 16),
              CampoMultiSelecao<DTOCategoriaMusica>(
                opcoes: _categoriasMock,
                rotaCadastro: Rotas.cadastroCategoriaMusica,
                valoresSelecionados: _categoriasSelecionadas,
                rotulo: 'Categorias de Música',
                textoPadrao: 'Selecione categorias',
                eObrigatorio: true,
                onChanged: (selecionados) {
                  setState(() {
                    _categoriasSelecionadas
                      ..clear()
                      ..addAll(selecionados);
                  });
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Links de Vídeo Aula (opcional)',
              ),
              const SizedBox(height: 8),
              ..._links.asMap().entries.map((entry) {
                int index = entry.key;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: CampoUrl(
                          rotulo: 'Link do Vídeo Aula ${index + 1}',
                          dica: 'https://...',
                          eObrigatorio: false,
                          onChanged: (value) => _atualizarLink(index, 'url', value),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: CampoTexto(
                          rotulo: 'Descrição',
                          dica: 'Ex: Playlist oficial',
                          eObrigatorio: false,
                          onChanged: (value) => _atualizarLink(index, 'descricao', value),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Remover link',
                        onPressed: () => _removerLink(index),
                      ),
                    ],
                  ),
                );
              }),
              TextButton.icon(
                onPressed: _adicionarLink,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar Link'),
              ),
              const SizedBox(height: 16),
              CampoTexto(
                rotulo: 'Descrição',
                dica: 'Descrição da música (opcional)',
                maxLinhas: 3,
                eObrigatorio: false,
                onChanged: (value) => _descricao = value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
