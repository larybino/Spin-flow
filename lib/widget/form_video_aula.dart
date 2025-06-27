import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto_video_aula.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_video_aula.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

class FormVideoAula extends StatefulWidget {
  final DTOVideoAula? videoAula;
  const FormVideoAula({super.key, this.videoAula});

  @override
  State<FormVideoAula> createState() => _FormVideoAulaState();
}

class _FormVideoAulaState extends State<FormVideoAula> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _linkController;
  bool _ativo = true;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.videoAula?.nome ?? '');
    _linkController = TextEditingController(
      text: widget.videoAula?.linkVideo ?? '',
    );
    _ativo = widget.videoAula?.ativo ?? true;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  void _salvar() async {
    if (_formKey.currentState?.validate() ?? false) {
      final dto = DTOVideoAula(
        id: widget.videoAula?.id,
        nome: _nomeController.text.trim(),
        linkVideo: _linkController.text.trim().isEmpty
            ? null
            : _linkController.text.trim(),
        ativo: _ativo,
      );
      final dao = DAOVideoAula();
      await dao.salvar(dto); // Salva no banco de dados
      Navigator.pushNamed(
        context,
        Rotas.listaVideoAula,
      ); // Troque pelo nome da rota da lista // Retorna para a tela anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.videoAula == null ? 'Nova Vídeo-aula' : 'Editar Vídeo-aula',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _salvar,
            tooltip: 'Salvar',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Informe o nome da vídeo-aula'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _linkController,
                decoration: const InputDecoration(
                  labelText: 'Link do vídeo',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    final urlPattern = r'^(http|https):\/\/';
                    if (!RegExp(urlPattern).hasMatch(value.trim())) {
                      return 'Informe uma URL válida (http ou https)';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile.adaptive(
                value: _ativo,
                onChanged: (v) => setState(() => _ativo = v),
                title: const Text('Ativa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
