import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto_artista_banda.dart';
import 'package:spin_flow/widget/componentes/app_bar_salvar.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_url.dart';

class FormArtistaBanda extends StatefulWidget {
  const FormArtistaBanda({super.key});

  @override
  State<FormArtistaBanda> createState() => _FormArtistaBandaState();
}

class _FormArtistaBandaState extends State<FormArtistaBanda> {
  final _formKey = GlobalKey<FormState>();
  
  // Campos do formulário
  String? _nome;
  String? _descricao;
  String? _link;
  String? _foto;
  bool _ativo = true;

  void _limparFormulario() {
    setState(() {
      _nome = null;
      _descricao = null;
      _link = null;
      _foto = null;
      _ativo = true;
    });
    _formKey.currentState?.reset();
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      // Criar DTO
      final dto = DTOArtistaBanda(
        nome: _nome ?? '',
        descricao: _descricao,
        link: _link,
        foto: _foto,
        ativo: _ativo,
      );

      // Mostrar dados em dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Artista/Banda Criado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome: ${dto.nome}'),
              Text('Descrição: ${dto.descricao ?? 'Não informado'}'),
              Text('Link: ${dto.link ?? 'Não informado'}'),
              Text('Foto: ${dto.foto ?? 'Não informado'}'),
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
        SnackBar(content: Text('Artista/Banda salvo com sucesso! ${dto.nome}')),
      );

      // Limpar formulário
      _limparFormulario();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSalvar(  
        titulo: 'Cadastro de Artista/Banda',
        aoSalvar: _salvar,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CampoTexto(
                rotulo: 'Nome',
                dica: 'Artista ou Banda',
                eObrigatorio: true,
                onChanged: (value) => _nome = value,
              ),
              CampoTexto(
                rotulo: 'Descrição',
                dica: 'Informações adicionais sobre o artista ou banda',
                maxLinhas: 4,
                eObrigatorio: false,
                onChanged: (value) => _descricao = value,
              ),
              CampoUrl(
                rotulo: 'Link relacionado',
                dica: 'Página oficial, bibliografia, playlist etc.',
                eObrigatorio: false,
                onChanged: (value) => _link = value,
              ),
              CampoUrl(
                rotulo: 'URL da foto',
                dica: 'Imagem representativa da banda ou artista',
                eObrigatorio: false,
                onChanged: (value) => _foto = value,
              ),
              SwitchListTile(
                value: _ativo,
                onChanged: (valor) => setState(() => _ativo = valor),
                title: const Text('Ativo'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
