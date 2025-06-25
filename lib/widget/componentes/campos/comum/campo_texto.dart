import 'package:flutter/material.dart';
import 'package:spin_flow/configuracoes/erro.dart';

class CampoTexto extends StatelessWidget {
  final TextEditingController? controle;
  final String? valorInicial;
  final String rotulo;
  final String dica;
  final String mensagemErro;
  final int maxLinhas;
  final bool eObrigatorio;
  final void Function(String)? onChanged;

  const CampoTexto({
    super.key,
    this.controle,
    this.valorInicial,
    required this.rotulo,
    required this.dica,
    this.mensagemErro = Erro.obrigatorio,
    this.maxLinhas = 1,
    this.eObrigatorio = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controle,
      maxLines: maxLinhas,
      decoration: InputDecoration(
        labelText: rotulo,
        hintText: dica,
      ),
      validator: (value) {
        if (eObrigatorio && (value == null || value.isEmpty)) {
          return mensagemErro;
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}