import 'package:flutter/material.dart';

class CampoSenha extends StatelessWidget {
  final TextEditingController? controle;
  final String rotulo;
  final String dica;
  final String mensagemErro;
  final void Function(String)? onChanged;

  const CampoSenha({
    super.key, 
    this.controle, 
    required this.rotulo, 
    required this.dica, 
    required this.mensagemErro,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controle,
      obscureText: true,
      decoration: InputDecoration(
        labelText: rotulo,
        //border: const OutlineInputBorder(),
        hintText: dica,
      ),
      validator: (value) =>
          value == null || value.isEmpty ? mensagemErro : null,
      onChanged: onChanged,
    );
  }
}