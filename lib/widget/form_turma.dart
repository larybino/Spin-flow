import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto_turma.dart';
import 'package:spin_flow/dto/dto_sala.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_hora.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_numero.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_opcoes.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';
import 'package:spin_flow/banco/mock/mock_salas.dart';

import 'componentes/campos/selecao_multipla/campo_dias_semana.dart';

class FormTurma extends StatefulWidget {
  const FormTurma({super.key});

  @override
  State<FormTurma> createState() => _FormTurmaState();
}

class _FormTurmaState extends State<FormTurma> {
  final _formKey = GlobalKey<FormState>();

  // Campos do formulário
  String? _nome;
  String? _descricao;
  String? _duracao;
  List<String> _diasSelecionados = [];
  TimeOfDay? _horarioInicio;
  DTOSala? _salaSelecionada;
  bool _ativo = true;

  void _limparFormulario() {
    setState(() {
      _nome = null;
      _descricao = null;
      _duracao = null;
      _diasSelecionados = [];
      _horarioInicio = null;
      _salaSelecionada = null;
      _ativo = true;
    });
    _formKey.currentState?.reset();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Validação extra: dias selecionados e horário
      if (_diasSelecionados.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecione ao menos um dia da semana')),
        );
        return;
      }
      if (_horarioInicio == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecione o horário de início')),
        );
        return;
      }
      if (_salaSelecionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecione a sala')),
        );
        return;
      }

      // Criar DTO
      final dto = DTOTurma(
        nome: _nome ?? '',
        descricao: _descricao,
        diasSemana: _diasSelecionados,
        horarioInicio: _horarioInicio?.format(context) ?? '',
        duracaoMinutos: int.tryParse(_duracao ?? '0') ?? 0,
        sala: _salaSelecionada!,
        ativo: _ativo,
      );

      // Mostrar dados em dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Turma Criada'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nome: ${dto.nome}'),
                Text('Descrição: ${dto.descricao ?? 'Não informado'}'),
                Text('Dias: ${dto.diasSemana.join(', ')}'),
                Text('Horário: ${dto.horarioInicio}'),
                Text('Duração: ${dto.duracaoMinutos} minutos'),
                Text('Sala: ${dto.sala.nome}'),
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
        SnackBar(content: Text('Turma salva com sucesso! ${dto.nome}')),
      );

      // Limpar formulário
      _limparFormulario();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Turma')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CampoTexto(
                rotulo: 'Nome da turma',
                dica: 'Ex: Spinning Avançado 18h',
                mensagemErro: 'Informe o nome da turma',
                eObrigatorio: true,
                onChanged: (value) => _nome = value,
              ),
              const SizedBox(height: 16),
              CampoTexto(
                rotulo: 'Descrição (opcional)',
                dica: 'Nível, foco, observações',
                eObrigatorio: false,
                onChanged: (value) => _descricao = value,
              ),
              const SizedBox(height: 16),
              CampoDiasSemana(
                diasSelecionados: _diasSelecionados,
                onChanged: (List<String> novosDias) {
                  setState(() {
                    _diasSelecionados = novosDias;
                  });
                },
              ),
              const SizedBox(height: 16),
              CampoHora(
                rotulo: 'Hora Inicial',
                horaInicial: _horarioInicio,
                onChanged: (novoHorario) {
                  setState(() {
                    _horarioInicio = novoHorario;
                  });
                },
              ),
              const SizedBox(height: 16),
              CampoNumero(
                rotulo: 'Duração da aula (minutos)',
                dica: 'Ex: 45',
                eObrigatorio: true,
                limiteMinimo: 1,
                limiteMaximo: 180,
                onChanged: (value) => _duracao = value,
              ),
              const SizedBox(height: 16),
              CampoOpcoes<DTOSala>(
                opcoes: mockSalas,
                valorSelecionado: _salaSelecionada,
                rotulo: 'Sala / Local da aula',
                rotaCadastro: Rotas.cadastroSala,
                onChanged: (DTOSala? novaSala) {
                  setState(() {
                    _salaSelecionada = novaSala;
                  });
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Ativo'),
                value: _ativo,
                onChanged: (bool? valor) {
                  setState(() {
                    _ativo = valor ?? true;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Salvar turma'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
