import 'package:flutter/material.dart';
import 'package:spin_flow/configuracoes/erro.dart';

enum DiaSemana {
  segunda,
  terca,
  quarta,
  quinta,
  sexta,
  sabado,
  domingo,
}

extension DiaSemanaExt on DiaSemana {
  String get label {
    switch (this) {
      case DiaSemana.segunda:
        return 'Seg';
      case DiaSemana.terca:
        return 'Ter';
      case DiaSemana.quarta:
        return 'Qua';
      case DiaSemana.quinta:
        return 'Qui';
      case DiaSemana.sexta:
        return 'Sex';
      case DiaSemana.sabado:
        return 'Sáb';
      case DiaSemana.domingo:
        return 'Dom';
    }
  }
}

extension ConversaoListaDias on Set<DiaSemana> {
  List<String> get comoListaDeNomes => map((d) => d.name).toList();
}

extension ConversaoListaNomes on List<String> {
  Set<DiaSemana> get comoSetDeDias =>
      map((nome) => DiaSemana.values.firstWhere((d) => d.name == nome)).toSet();
}

class CampoDiasSemana extends FormField<Set<DiaSemana>> {
  CampoDiasSemana({
    super.key,
    required Set<DiaSemana> diasSelecionados,
    required String rotulo,
    bool eObrigatorio = true,
    String mensagemErro = Erro.obrigatorio,
    void Function(Set<DiaSemana>)? onChanged,
  }) : super(
          initialValue: diasSelecionados,
          validator: (value) {
            if (eObrigatorio && (value == null || value.isEmpty)) {
              return mensagemErro;
            }
            return null;
          },
          builder: (FormFieldState<Set<DiaSemana>> state) {
            return InputDecorator(
              decoration: InputDecoration(
                labelText: rotulo,
                errorText: state.errorText,
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: Wrap(
                spacing: 8,
                children: DiaSemana.values.map((dia) {
                  final selecionado = state.value!.contains(dia);
                  return FilterChip(
                    label: Text(dia.label),
                    selected: selecionado,
                    onSelected: (bool seleciona) {
                      final novoSet = Set<DiaSemana>.from(state.value!);
                      if (seleciona) {
                        novoSet.add(dia);
                      } else {
                        novoSet.remove(dia);
                      }
                      state.didChange(novoSet);
                      if (onChanged != null) onChanged(novoSet);
                    },
                  );
                }).toList(),
              ),
            );
          },
        );
}
