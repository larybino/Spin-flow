import 'package:flutter/material.dart';
import 'package:spin_flow/configuracoes/erro.dart';

class CampoHora extends FormField<TimeOfDay> {
  CampoHora({
    super.key,
    TimeOfDay? horaInicial,
    required String rotulo,
    bool eObrigatorio = true,
    String mensagemErro = Erro.obrigatorio,
    void Function(TimeOfDay)? onChanged,
  }) : super(
          initialValue: horaInicial,
          validator: (value) {
            if (eObrigatorio && value == null) {
              return mensagemErro;
            }
            return null;
          },
          builder: (FormFieldState<TimeOfDay> state) {
            String textoHora = state.value != null
                ? state.value!.format(state.context)
                : 'Selecione o horário';

            return InkWell(
              onTap: () async {
                TimeOfDay? novaHora = await showTimePicker(
                  context: state.context,
                  initialTime: state.value ?? TimeOfDay.now(),
                );
                if (novaHora != null) {
                  state.didChange(novaHora);
                  if (onChanged != null) onChanged(novaHora);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: rotulo,
                  errorText: state.errorText,
                  border: const OutlineInputBorder(),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  suffixIcon: const Icon(Icons.access_time),
                ),
                child: Text(
                  textoHora,
                  style: TextStyle(
                    fontSize: 16,
                    color: state.value != null
                        ? Colors.black87
                        : Colors.grey[600],
                  ),
                ),
              ),
            );
          },
        );
}
