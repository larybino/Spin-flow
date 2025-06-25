import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:spin_flow/configuracoes/erro.dart';

class CampoTelefone extends StatelessWidget {
  final TextEditingController? controle;
  final String rotulo;
  final String dica;
  final String? Function(String?)? validator;
  final bool eObrigatorio;
  final void Function(String)? onChanged;

  const CampoTelefone({
    super.key,
    this.controle,
    this.rotulo = 'Telefone',
    this.dica = '(00) 00000-0000',
    this.validator,
    this.eObrigatorio = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final mascara = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
    );

    return TextFormField(
      controller: controle,
      keyboardType: TextInputType.phone,
      inputFormatters: [mascara],
      decoration: InputDecoration(
        labelText: rotulo,
        hintText: dica,
        prefixIcon: const Icon(Icons.phone),
      ),
      validator: validator ?? (value) {
        if (value == null || value.trim().isEmpty) {
          if (eObrigatorio) return 'Informe o telefone';
        } else {
          // Remove caracteres não numéricos para validação
          final numeros = value.replaceAll(RegExp(r'[^\d]'), '');
          if (numeros.length < 10 || numeros.length > 11) return Erro.telefoneInvalido;
        }
        return null;
      },
      onChanged: onChanged,
      autofillHints: const [AutofillHints.telephoneNumber],
    );
  }
}
