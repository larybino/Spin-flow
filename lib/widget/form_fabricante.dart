import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto_fabricante.dart';
import 'package:spin_flow/widget/componentes/borda_com_titulo.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_email.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_telefone.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';

class FormFabricante extends StatefulWidget {
  const FormFabricante({super.key});

  @override
  State<FormFabricante> createState() => _FormFabricanteState();
}

class _FormFabricanteState extends State<FormFabricante> {
  final _formKey = GlobalKey<FormState>();
  int? id;

  // Campos do formulário
  String? _nome;
  String? _descricao;
  String? _responsavel;
  String? _email;
  String? _telefone;
  bool _ativo = true;

  void _limparFormulario() {
    setState(() {
      _nome = null;
      _descricao = null;
      _responsavel = null;
      _email = null;
      _telefone = null;
      _ativo = true;
    });
    _formKey.currentState?.reset();
  }

  Widget _fabricante() {
    return BordaComTitulo(
      titulo: 'Fabricante',
      filhos: [
        CampoTexto(
          rotulo: 'Nome*',
          dica: 'Nome do fabricante',
          eObrigatorio: true,
          onChanged: (value) => _nome = value,
        ),
        const SizedBox(height: 12),
        CampoTexto(
          rotulo: 'Descrição',
          dica: 'Descrição opcional',
          eObrigatorio: false,
          onChanged: (value) => _descricao = value,
        ),
        const SizedBox(height: 24),
        SwitchListTile(
          title: const Text('Ativo'),
          value: _ativo,
          onChanged: (valor) {
            setState(() => _ativo = valor);
          },
        ),
      ],
    );
  }

  Widget _contato() {
    return BordaComTitulo(
      titulo: 'Contato',
      filhos: [
        CampoTexto(
          rotulo: 'Responsável',
          dica: 'Nome do responsável',
          eObrigatorio: false,
          onChanged: (value) => _responsavel = value,
        ),
        const SizedBox(height: 16),
        CampoEmail(
          rotulo: 'E-mail',
          eObrigatorio: false,
          onChanged: (value) => _email = value,
        ),
        const SizedBox(height: 16),
        CampoTelefone(
          rotulo: 'Telefone',
          eObrigatorio: false,
          onChanged: (value) => _telefone = value,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Fabricante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _fabricante(),
              _contato(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Criar DTO
                    final dto = DTOFabricante(
                      id: id,
                      nome: _nome ?? '',
                      descricao: _descricao,
                      nomeContatoPrincipal: _responsavel,
                      emailContato: _email,
                      telefoneContato: _telefone,
                      ativo: _ativo,
                    );

                    // Mostrar dados em dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Fabricante Criado'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nome: ${dto.nome}'),
                            Text('Descrição: ${dto.descricao ?? 'Não informado'}'),
                            Text('Responsável: ${dto.nomeContatoPrincipal ?? 'Não informado'}'),
                            Text('Email: ${dto.emailContato ?? 'Não informado'}'),
                            Text('Telefone: ${dto.telefoneContato ?? 'Não informado'}'),
                            Text('Ativo: ${dto.ativo ? 'Sim' : 'Não'}'),
                          ],
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
                      SnackBar(content: Text('Fabricante salvo com sucesso! ${dto.nome}')),
                    );

                    // Limpar formulário
                    _limparFormulario();
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

