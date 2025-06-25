import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto_tipo_manutencao.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';

class FormTipoManutencaoTela extends StatefulWidget {
  const FormTipoManutencaoTela({super.key});

  @override
  State<FormTipoManutencaoTela> createState() => _FormTipoManutencaoTelaState();
}

class _FormTipoManutencaoTelaState extends State<FormTipoManutencaoTela> {
  final _formKey = GlobalKey<FormState>();
  
  // Campos do formulário
  String? _descricao;
  bool _ativa = true;

  void _limparFormulario() {
    setState(() {
      _descricao = null;
      _ativa = true;
    });
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro - Tipo de Manutenção')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CampoTexto(
                rotulo: 'Descrição',
                dica: 'pedal esquerdo, regulagem quebrada, pé-de-vela',
                eObrigatorio: true,
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
                    final dto = DTOTipoManutencao(
                      nome: _descricao ?? '',
                      ativa: _ativa,
                    );

                    // Mostrar dados em dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Tipo de Manutenção Criado'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Descrição: ${dto.nome}'),
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
                      SnackBar(content: Text('Tipo de manutenção salvo com sucesso! ${dto.nome}')),
                    );

                    // Limpar formulário
                    _limparFormulario();
                  }
                },
                child: const Text('Salvar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
