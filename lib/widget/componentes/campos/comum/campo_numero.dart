import 'package:flutter/material.dart';
import 'package:spin_flow/configuracoes/erro.dart';

class CampoNumero extends FormField<String> {
  CampoNumero({
    super.key,
    TextEditingController? controle,
    required String rotulo,
    String dica = '',
    String mensagemErro = Erro.obrigatorio,
    bool eObrigatorio = true,
    bool aceitaNegativo = false,
    int? limiteMaximo,
    int limiteMinimo = 0,
    void Function(String)? onChanged,
  }) : super(
          initialValue: controle?.text,
          validator: (value) {
            if (eObrigatorio && (value == null || value.isEmpty)) {
              return mensagemErro;
            }

            if (value != null && value.isNotEmpty) {
              final numero = int.tryParse(value);
              if (numero == null) {
                return 'Informe um número válido';
              }
              if (!aceitaNegativo && numero < 0) {
                return 'Não pode ser número negativo';
              }
              if (numero < limiteMinimo) {
                return 'Valor deve ser ≥ $limiteMinimo';
              }
              if (limiteMaximo != null && numero > limiteMaximo) {
                return 'Valor deve ser ≤ $limiteMaximo';
              }
            }

            return null;
          },
          builder: (FormFieldState<String> field) {
            final controller = controle ?? TextEditingController(text: field.value);
            
            return TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: rotulo,
                hintText: dica,
                errorText: field.errorText,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                field.didChange(value);
                onChanged?.call(value);
              },
            );
          },
        );
}
