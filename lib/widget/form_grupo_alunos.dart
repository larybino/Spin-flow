import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto_grupo_alunos.dart';
import 'package:spin_flow/dto/dto_aluno.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/campos/selecao_multipla/campo_busca_multipla.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';
import 'package:spin_flow/banco/mock/mock_alunos.dart';

class FormGrupoAlunos extends StatefulWidget {
  const FormGrupoAlunos({super.key});

  @override
  State<FormGrupoAlunos> createState() => _FormGrupoAlunosState();
}

class _FormGrupoAlunosState extends State<FormGrupoAlunos> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeControlador = TextEditingController();
  final TextEditingController _descricaoControlador = TextEditingController();

  // Campos do formulário
  String? _nome;
  String? _descricao;
  List<DTOAluno> _alunosSelecionados = [];

  // Função para validar que há pelo menos 1 aluno selecionado
  String? _validaAlunosSelecionados() {
    if (_alunosSelecionados.isEmpty) {
      return 'Selecione pelo menos um aluno';
    }
    return null;
  }

  void _limparFormulario() {
    setState(() {
      _nome = null;
      _descricao = null;
      _alunosSelecionados.clear();
    });
    _formKey.currentState?.reset();
  }

  void _salvar() {
    final formValido = _formKey.currentState?.validate() ?? false;
    final alunosValidos = _validaAlunosSelecionados() == null;

    if (formValido && alunosValidos) {
      // Criar DTO
      final dto = DTOGrupoAlunos(
        nome: _nome ?? '',
        descricao: _descricao,
        alunos: List.from(_alunosSelecionados),
      );

      // Mostrar dados em dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Grupo de Alunos Criado'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nome: ${dto.nome}'),
                Text('Descrição: ${dto.descricao ?? 'Não informado'}'),
                const SizedBox(height: 8),
                Text('Alunos (${dto.alunos.length}):', style: const TextStyle(fontWeight: FontWeight.bold)),
                ...dto.alunos.map((aluno) => 
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 2),
                    child: Text('• ${aluno.nome}'),
                  ),
                ),
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
        SnackBar(content: Text('Grupo salvo com sucesso! ${dto.nome}')),
      );

      // Limpar formulário
      _limparFormulario();
    } else {
      if (!alunosValidos) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_validaAlunosSelecionados()!)),
        );
      }
    }
  }

  @override
  void dispose() {
    _nomeControlador.dispose();
    _descricaoControlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Grupo de Alunos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CampoTexto(
                controle: _nomeControlador,
                rotulo: 'Nome do Grupo',
                dica: 'Nome do grupo de alunos',
                eObrigatorio: true,
                aoAlterar: (value) => _nome = value,
              ),
              const SizedBox(height: 16),
              CampoTexto(
                controle: _descricaoControlador,
                rotulo: 'Descrição',
                dica: 'Descrição do grupo (opcional)',
                eObrigatorio: false,
                aoAlterar: (value) => _descricao = value,
              ),
              const SizedBox(height: 16),
              Text('Alunos'),
              const SizedBox(height: 8),
              CampoBuscaMultipla<DTOAluno>(
                opcoes: mockAlunos,
                valoresSelecionados: _alunosSelecionados,
                rotulo: 'Alunos do Grupo',
                textoPadrao: 'Digite para buscar alunos...',
                rotaCadastro: Rotas.cadastroAluno,
                onChanged: (lista) => setState(() => _alunosSelecionados = lista),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvar,
                  child: const Text('Salvar'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
