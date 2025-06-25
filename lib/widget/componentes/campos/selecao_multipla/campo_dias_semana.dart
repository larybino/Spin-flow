import 'package:flutter/material.dart';

class CampoDiasSemana extends StatefulWidget {
  final List<String> diasSelecionados; // exemplo: ['Seg', 'Qua', 'Sex']
  final void Function(List<String>) onChanged;
  final bool eObrigatorio;
  final String mensagemErro;

  const CampoDiasSemana({
    super.key,
    this.diasSelecionados = const [],
    required this.onChanged,
    this.eObrigatorio = true,
    this.mensagemErro = 'Selecione pelo menos um dia da semana',
  });

  @override
  State<CampoDiasSemana> createState() => _CampoDiasSemanaState();
}

class _CampoDiasSemanaState extends State<CampoDiasSemana> {
  static const List<String> todosDias = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
  late List<String> selecionados;
  String? erro;

  @override
  void initState() {
    super.initState();
    selecionados = List.from(widget.diasSelecionados);
  }

  void _toggleDia(String dia) {
    setState(() {
      if (selecionados.contains(dia)) {
        selecionados.remove(dia);
      } else {
        selecionados.add(dia);
      }
      erro = null;
    });
    widget.onChanged(selecionados);
  }

  bool validar() {
    if (widget.eObrigatorio && selecionados.isEmpty) {
      setState(() {
        erro = widget.mensagemErro;
      });
      return false;
    }
    setState(() {
      erro = null;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: todosDias.map((dia) {
            final estaSelecionado = selecionados.contains(dia);
            return ChoiceChip(
              label: Text(dia),
              selected: estaSelecionado,
              onSelected: (_) => _toggleDia(dia),
            );
          }).toList(),
        ),
        if (erro != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              erro!,
              style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
