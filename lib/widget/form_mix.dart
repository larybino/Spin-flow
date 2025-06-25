import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto_musica.dart';
import 'package:spin_flow/dto/dto_mix.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_data.dart';
import 'package:spin_flow/widget/componentes/campos/selecao_unica/campo_busca_opcoes.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/banco/mock/mock_musicas.dart';

class FormMix extends StatefulWidget {
  const FormMix({super.key});

  @override
  State<FormMix> createState() => _FormMixState();
}

class _FormMixState extends State<FormMix> {
  final _formKey = GlobalKey<FormState>();
  
  // Campos do formulário
  String? _nomeMix;
  String? _descricao;
  DateTime? _dataInicio;
  DateTime? _dataFim;
  bool _ativo = true;
  final List<DTOMusica> _musicasSelecionadas = [];

  void _adicionarMusica(DTOMusica? musica) {
    if (musica != null && !_musicasSelecionadas.any((m) => m.id == musica.id)) {
      setState(() => _musicasSelecionadas.add(musica));
    }
  }

  void _removerMusica(DTOMusica musica) {
    setState(() => _musicasSelecionadas.removeWhere((m) => m.id == musica.id));
  }

  void _limparFormulario() {
    setState(() {
      _nomeMix = null;
      _descricao = null;
      _dataInicio = null;
      _dataFim = null;
      _ativo = true;
      _musicasSelecionadas.clear();
    });
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Mix')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CampoTexto(
              rotulo: 'Nome do Mix',
              dica: 'Ex: Mix Power Março 2025',
              eObrigatorio: true,
              onChanged: (value) => _nomeMix = value,
            ),
            const SizedBox(height: 16),
            CampoData(
              label: 'Data de início de uso',
              eObrigatorio: true,
              valor: _dataInicio,
              onChanged: (data) => setState(() => _dataInicio = data),
            ),
            const SizedBox(height: 16),
            CampoData(
              label: 'Data de encerramento (opcional)',
              eObrigatorio: false,
              valor: _dataFim,
              onChanged: (data) => setState(() => _dataFim = data),
            ),
            const SizedBox(height: 16),
            CampoBuscaOpcoes<DTOMusica>(
              opcoes: mockMusicas,
              rotulo: 'Música',
              eObrigatorio: false,
              textoPadrao: 'Selecione as músicas do mix',
              rotaCadastro: Rotas.cadastroMusica,
              onChanged: _adicionarMusica,
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Adicionar música ao mix'),
            ),
            const SizedBox(height: 8),
            const Text('Músicas no mix:', style: TextStyle(fontWeight: FontWeight.bold)),
            ..._musicasSelecionadas.map(
              (musica) => ListTile(
                title: Text('${musica.nome} - ${musica.artista.nome}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removerMusica(musica),
                ),
              ),
            ),
            const SizedBox(height: 16),
            CampoTexto(
              rotulo: 'Descrição / Observações',
              dica: 'Ex: Mix voltado para treinos intensos...',
              maxLinhas: 4,
              eObrigatorio: false,
              onChanged: (value) => _descricao = value,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: _ativo,
              onChanged: (valor) => setState(() => _ativo = valor),
              title: const Text('Ativo'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() && _musicasSelecionadas.isNotEmpty) {
                  // Criar DTO
                  final dto = DTOMix(
                    nome: _nomeMix ?? '',
                    descricao: _descricao,
                    dataInicio: _dataInicio!,
                    dataFim: _dataFim,
                    musicas: _musicasSelecionadas,
                    ativo: _ativo,
                  );

                  // Mostrar dados em dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Mix Criado'),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nome: ${dto.nome}'),
                            Text('Descrição: ${dto.descricao ?? 'Não informado'}'),
                            Text('Data Início: ${dto.dataInicio.toString().split(' ')[0]}'),
                            if (dto.dataFim != null)
                              Text('Data Fim: ${dto.dataFim.toString().split(' ')[0]}'),
                            Text('Ativo: ${dto.ativo ? 'Sim' : 'Não'}'),
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
                    SnackBar(content: Text('Mix salvo com sucesso! ${dto.nome}')),
                  );

                  // Limpar formulário
                  _limparFormulario();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
                  );
                }
              },
              child: const Text('Salvar Mix'),
            ),
          ],
        ),
      ),
    );
  }
}
