import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto_categoria_musica.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';

class FormCategoriaMusica extends StatefulWidget {
  const FormCategoriaMusica({super.key});

  @override
  State<FormCategoriaMusica> createState() => _FormCategoriaMusicaState();
}

class _FormCategoriaMusicaState extends State<FormCategoriaMusica> {
  final _formKey = GlobalKey<FormState>();
  
  // Campos do formulário
  String? _nome;
  String? _descricao;
  bool _ativa = true;

  void _limparFormulario() {
    setState(() {
      _nome = null;
      _descricao = null;
      _ativa = true;
    });
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Categoria de Música')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CampoTexto(    
                rotulo: 'Nome',
                dica: 'cadência, ritmo, coreografia, força, relaxamento, aquecimento',
                eObrigatorio: true,
                onChanged: (value) => _nome = value,
              ),
              const SizedBox(height: 16),
              CampoTexto(
                rotulo: 'Descrição',
                dica: 'Descrição da coreografia\nExemplo para "Coreografia" → músicas que exigem coordenação motora e passos específicos',
                maxLinhas: 3,
                eObrigatorio: false,
                onChanged: (value) => _descricao = value,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Ativa'),
                value: _ativa,
                onChanged: (valor) {
                  setState(() => _ativa = valor);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Criar DTO
                    final dto = DTOCategoriaMusica(
                      nome: _nome ?? '',
                      descricao: _descricao,
                      ativa: _ativa,
                    );

                    // Mostrar dados em dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Categoria Criada'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nome: ${dto.nome}'),
                            Text('Descrição: ${dto.descricao ?? 'Não informado'}'),
                            Text('Ativa: ${dto.ativa ? 'Sim' : 'Não'}'),
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
                      SnackBar(content: Text('Categoria salva com sucesso! ${dto.nome}')),
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

 /*
Categorias para músicas (nomes sugestivos):
Cadência — músicas que definem ritmo e velocidade do treino
Coreografia — músicas que exigem coordenação motora e passos específicos
Força — músicas para exercícios que trabalham força e resistência
Perna — músicas focadas em exercícios para membros inferiores
Braço — músicas para exercícios focados em membros superiores
Ritmo — músicas com batidas envolventes para manter a energia
Relaxamento — músicas suaves para alongamento, descanso e desaceleração
Animação — músicas alegres e motivadoras para divertir e estimular
Intervalo — músicas para momentos de pausa ativa, recuperação rápida
Aquecimento — músicas para preparar o corpo no início da aula
Desaquecimento — músicas para finalização, relaxar e diminuir o esforço
Explosão — músicas com batidas fortes para picos de esforço e sprint
Core — músicas para exercícios focados na região do abdômen e tronco
  */
