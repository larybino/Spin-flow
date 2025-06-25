import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto.dart';

class CampoMultiSelecao<T extends DTO> extends StatefulWidget {
  final List<T> opcoes;
  final List<T> valoresSelecionados;
  final String rotulo;
  final bool eObrigatorio;
  final String textoPadrao;
  final String rotaCadastro;
  final void Function(List<T>)? onChanged;

  const CampoMultiSelecao({
    super.key,
    required this.opcoes,
    required this.valoresSelecionados,
    required this.rotulo,
    this.eObrigatorio = true,
    this.textoPadrao = 'Selecione opções',
    required this.rotaCadastro,
    this.onChanged,
  });

  @override
  State<CampoMultiSelecao<T>> createState() => _CampoMultiSelecaoState<T>();
}

class _CampoMultiSelecaoState<T extends DTO> extends State<CampoMultiSelecao<T>> {
  late List<T> _opcoesInternas;
  late List<T> _selecionadosInternos;

  @override
  void initState() {
    super.initState();
    _opcoesInternas = List<T>.from(widget.opcoes);
    _selecionadosInternos = List<T>.from(widget.valoresSelecionados);
  }

  Future<void> _navegarParaCadastro() async {
    final novoItem = await Navigator.pushNamed(context, widget.rotaCadastro);
    if (novoItem != null && novoItem is T) {
      setState(() {
        _opcoesInternas.add(novoItem);
        _selecionadosInternos.add(novoItem);
        widget.onChanged?.call(_selecionadosInternos);
      });
    }
  }

  String? _validar() {
    if (widget.eObrigatorio && _selecionadosInternos.isEmpty) {
      return 'Selecione pelo menos uma opção';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(widget.rotulo, style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            IconButton(
              onPressed: _navegarParaCadastro,
              icon: const Icon(Icons.add),
              tooltip: 'Adicionar novo',
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _validar() == null ? Colors.grey : Colors.red,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: ExpansionTile(
            title: Text(
              _selecionadosInternos.isEmpty
                  ? widget.textoPadrao
                  : _selecionadosInternos.map((e) => e.nome).join(', '),
            ),
            children: _opcoesInternas.map((item) {
              final estaSelecionado = _selecionadosInternos.contains(item);
              return CheckboxListTile(
                title: Text(item.nome),
                value: estaSelecionado,
                onChanged: (bool? novoValor) {
                  setState(() {
                    if (novoValor == true) {
                      if (!_selecionadosInternos.contains(item)) {
                        _selecionadosInternos.add(item);
                      }
                    } else {
                      _selecionadosInternos.remove(item);
                    }
                    widget.onChanged?.call(_selecionadosInternos);
                  });
                },
              );
            }).toList(),
          ),
        ),
        if (_validar() != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 12),
            child: Text(
              _validar()!,
              style: TextStyle(color: Colors.red[700], fontSize: 12),
            ),
          ),
      ],
    );
  }
}
