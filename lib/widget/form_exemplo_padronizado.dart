import 'package:flutter/material.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_email.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_telefone.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_numero.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_data.dart';

class FormExemploPadronizado extends StatefulWidget {
  const FormExemploPadronizado({super.key});

  @override
  State<FormExemploPadronizado> createState() => _FormExemploPadronizadoState();
}

class _FormExemploPadronizadoState extends State<FormExemploPadronizado> {
  final _formKey = GlobalKey<FormState>();
  
  // Campos do formulário
  String? _nome;
  String? _email;
  String? _telefone;
  String? _idade;
  DateTime? _dataNascimento;

  void _limparFormulario() {
    setState(() {
      _nome = null;
      _email = null;
      _telefone = null;
      _idade = null;
      _dataNascimento = null;
    });
    _formKey.currentState?.reset();
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      // Criar dados do formulário
      final dados = {
        'nome': _nome ?? '',
        'email': _email ?? '',
        'telefone': _telefone ?? '',
        'idade': _idade ?? '',
        'dataNascimento': _dataNascimento?.toString().split(' ')[0] ?? 'Não informado',
      };

      // Mostrar dados em dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Formulário Enviado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome: ${dados['nome']}'),
              Text('Email: ${dados['email']}'),
              Text('Telefone: ${dados['telefone']}'),
              Text('Idade: ${dados['idade']}'),
              Text('Data Nascimento: ${dados['dataNascimento']}'),
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
        SnackBar(content: Text('Formulário salvo com sucesso! ${dados['nome']}')),
      );

      // Limpar formulário
      _limparFormulario();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exemplo Formulário Padronizado')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Campo texto usando FormField (sem controller)
            CampoTexto(
              rotulo: 'Nome',
              dica: 'Digite seu nome completo',
              eObrigatorio: true,
              onChanged: (value) => _nome = value,
            ),
            const SizedBox(height: 16),
            
            // Campo email usando FormField (sem controller)
            CampoEmail(
              rotulo: 'E-mail',
              eObrigatorio: true,
              onChanged: (value) => _email = value,
            ),
            const SizedBox(height: 16),
            
            // Campo telefone usando FormField (sem controller)
            CampoTelefone(
              rotulo: 'Telefone',
              eObrigatorio: true,
              onChanged: (value) => _telefone = value,
            ),
            const SizedBox(height: 16),
            
            // Campo número usando FormField (sem controller)
            CampoNumero(
              rotulo: 'Idade',
              dica: 'Digite sua idade',
              eObrigatorio: true,
              limiteMinimo: 0,
              limiteMaximo: 120,
              onChanged: (value) => _idade = value,
            ),
            const SizedBox(height: 16),
            
            // Campo data (já estava usando FormField)
            CampoData(
              label: 'Data de Nascimento',
              valor: _dataNascimento,
              eObrigatorio: true,
              onChanged: (data) => setState(() => _dataNascimento = data),
            ),
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: _salvar,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
} 