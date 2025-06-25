import 'package:flutter/material.dart';
import 'package:spin_flow/configuracoes/erro.dart';

class CampoEmail extends StatelessWidget {
  final TextEditingController? controle;
  final String rotulo;
  final String dica;
  final String? Function(String?)? validator;
  final bool eObrigatorio;
  final void Function(String)? onChanged;

  const CampoEmail({
    super.key,
    this.controle,
    this.rotulo = 'E-mail',
    this.dica = 'nome@provedora.com',
    this.validator,
    this.eObrigatorio = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controle,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: rotulo,
        hintText: dica,
        prefixIcon: const Icon(Icons.email),
      ),
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          if (eObrigatorio) return 'Informe o e-mail';
        } else {
          final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
          if (!regex.hasMatch(value)) return Erro.emailInvalido;
        }
        return null;
      },
      onChanged: onChanged,
      autofillHints: const [AutofillHints.email],
    );
  }
}