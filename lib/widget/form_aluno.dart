import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto_aluno.dart';
import 'package:spin_flow/widget/componentes/app_bar_salvar.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_data.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_email.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_telefone.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_url.dart';

class FormAluno extends StatefulWidget {
  const FormAluno({super.key}) ;

  @override
  State<FormAluno> createState() => _FormAlunoState();
}

class _FormAlunoState extends State<FormAluno> {
  final _formKey = GlobalKey<FormState>();

  // Campos do formulário
  String? _nome;
  String? _email;
  DateTime? _dataNascimento;
  String? _genero;
  String? _telefone;
  String? _urlFoto;
  String? _instagram;
  String? _facebook;
  String? _tiktok;
  String? _observacoes;
  bool _ativo = true;

  // Ícones sociais
  final Icon _iconInstagram = const Icon(Icons.camera_alt_outlined, color: Colors.purple);
  final Icon _iconFacebook = const Icon(Icons.facebook, color: Colors.blue);
  final Icon _iconTikTok = const Icon(Icons.music_note, color: Colors.black);

  // Validação simples para URLs de redes sociais
  String? _validarUrlRedeSocial(String? value, String rede) {
    if (value == null || value.trim().isEmpty) return null; // opcional
    final url = value.trim();
    final urlRegex = RegExp(r"^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/[\w\-._~:/?#[\]@!$&'()*+,;=]*)?$");
    if (!urlRegex.hasMatch(url)) {
      return 'Informe uma URL válida para $rede';
    }
    return null;
  }

  void _limparFormulario() {
    setState(() {
      _nome = null;
      _email = null;
      _dataNascimento = null;
      _genero = null;
      _telefone = null;
      _urlFoto = null;
      _instagram = null;
      _facebook = null;
      _tiktok = null;
      _observacoes = null;
      _ativo = true;
    });
    _formKey.currentState?.reset();
  }

  void _salvar() {
    if (_formKey.currentState?.validate() ?? false) {
      // Validar campos obrigatórios
      if ((_nome ?? '').isEmpty || (_email ?? '').isEmpty || (_genero ?? '').isEmpty || (_telefone ?? '').isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
        );
        return;
      }

      // Criar DTO
      final dto = DTOAluno(
        nome: _nome!,
        email: _email!,
        dataNascimento: _dataNascimento ?? DateTime.now(),
        genero: _genero!,
        telefone: _telefone!,
        urlFoto: _urlFoto,
        instagram: _instagram,
        facebook: _facebook,
        tiktok: _tiktok,
        observacoes: _observacoes,
        ativo: _ativo,
      );

      // Mostrar dados em dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Aluno Criado'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nome: ${dto.nome}'),
                Text('Email: ${dto.email}'),
                Text('Data Nascimento: ${dto.dataNascimento.toString().split(' ')[0]}'),
                Text('Gênero: ${dto.genero.isEmpty ? 'Não informado' : dto.genero}'),
                Text('Telefone: ${dto.telefone.isEmpty ? 'Não informado' : dto.telefone}'),
                Text('URL Foto: ${dto.urlFoto ?? 'Não informado'}'),
                Text('Instagram: ${dto.instagram ?? 'Não informado'}'),
                Text('Facebook: ${dto.facebook ?? 'Não informado'}'),
                Text('TikTok: ${dto.tiktok ?? 'Não informado'}'),
                Text('Observações: ${dto.observacoes ?? 'Não informado'}'),
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
        SnackBar(content: Text('Aluno salvo com sucesso! ${dto.nome}')),
      );

      // Limpar formulário
      _limparFormulario();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSalvar(
        titulo: 'Cadastro do Aluno',
        aoSalvar: _salvar,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CampoTexto(
                rotulo: 'Nome',
                dica: 'Nome completo',
                eObrigatorio: true,
                onChanged: (value) => _nome = value,
              ),
              const SizedBox(height: 12),
              CampoEmail(
                rotulo: 'E-mail',
                eObrigatorio: true,
                onChanged: (value) => _email = value,
              ),
              const SizedBox(height: 12),
              CampoData(
                label: 'Data de nascimento',
                valor: _dataNascimento,
                eObrigatorio: true,
                onChanged: (data) => setState(() => _dataNascimento = data),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Gênero',
                  border: OutlineInputBorder(),
                ),
                value: _genero,
                items: const [
                  DropdownMenuItem(value: 'masculino', child: Text('Masculino')),
                  DropdownMenuItem(value: 'feminino', child: Text('Feminino')),
                  DropdownMenuItem(value: 'outros', child: Text('Outros')),
                ],
                onChanged: (val) => setState(() => _genero = val),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Selecione o gênero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              CampoTelefone(
                rotulo: 'Telefone',
                eObrigatorio: true,
                onChanged: (value) => _telefone = value,
              ),
              const SizedBox(height: 12),
              CampoUrl(
                rotulo: 'URL da foto de perfil (opcional)',
                eObrigatorio: false,
                onChanged: (value) => _urlFoto = value,
              ),
              const SizedBox(height: 12),
              // Campos de redes sociais com ícones e validação condicional
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Instagram (opcional)',
                  prefixIcon: _iconInstagram,
                  border: const OutlineInputBorder(),
                  hintText: 'https://instagram.com/usuario',
                ),
                keyboardType: TextInputType.url,
                validator: (value) => _validarUrlRedeSocial(value, 'Instagram'),
                onChanged: (value) => _instagram = value,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Facebook (opcional)',
                  prefixIcon: _iconFacebook,
                  border: const OutlineInputBorder(),
                  hintText: 'https://facebook.com/usuario',
                ),
                keyboardType: TextInputType.url,
                validator: (value) => _validarUrlRedeSocial(value, 'Facebook'),
                onChanged: (value) => _facebook = value,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'TikTok (opcional)',
                  prefixIcon: _iconTikTok,
                  border: const OutlineInputBorder(),
                  hintText: 'https://tiktok.com/@usuario',
                ),
                keyboardType: TextInputType.url,
                validator: (value) => _validarUrlRedeSocial(value, 'TikTok'),
                onChanged: (value) => _tiktok = value,
              ),
              const SizedBox(height: 12),
              CampoTexto(
                rotulo: 'Observações',
                dica:  'opcional',
                maxLinhas: 4,
                eObrigatorio: false,
                onChanged: (value) => _observacoes = value,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Ativo'),
                value: _ativo,
                onChanged: (valor) => setState(() => _ativo = valor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
