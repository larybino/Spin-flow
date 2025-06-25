import 'package:flutter/material.dart';
import 'package:spin_flow/configuracoes/erro.dart';
import 'package:spin_flow/validacoes/validador_url.dart';

class CampoUrl extends StatelessWidget {
  final TextEditingController? controle;
  final String rotulo;
  final String dica;
  final String? Function(String?)? validator;
  final bool eObrigatorio;
  final void Function(String)? onChanged;

  const CampoUrl({
    super.key,
    this.controle,
    this.rotulo = 'Link',
    this.dica = 'https://site.com',
    this.validator,
    this.eObrigatorio = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controle,
      keyboardType: TextInputType.url,
      decoration: InputDecoration(
        labelText: rotulo,
        hintText: dica,
        prefixIcon: const Icon(Icons.link),
      ),
      validator: validator ?? (value) {
        if ((value == null || value.isEmpty)) {
          return eObrigatorio ? Erro.obrigatorio : null;
        }
        return ValidadorUrl.validarUrl(value);
      },
      onChanged: onChanged,
      autofillHints: const [AutofillHints.url],
    );
  }
}
