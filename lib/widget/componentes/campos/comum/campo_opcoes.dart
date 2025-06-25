import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto.dart';

class CampoOpcoes<T extends DTO> extends StatefulWidget {
  final List<T> opcoes;
  final T? valorSelecionado;
  final bool eObrigatorio;
  final String textoPadrao;
  final String rotulo;
  final void Function(T?)? onChanged;
  final String rotaCadastro; // Nova rota para cadastrar

  const CampoOpcoes({
    super.key,
    required this.opcoes,
    this.valorSelecionado,
    this.eObrigatorio = true,
    this.textoPadrao = 'Escolha uma opção',
    required this.rotulo,
    this.onChanged,
    required this.rotaCadastro,
  });

  @override
  State<CampoOpcoes<T>> createState() => _CampoOpcoesState<T>();
}

class _CampoOpcoesState<T extends DTO> extends State<CampoOpcoes<T>> {
  late List<T> _opcoesCampo;
  T? _valorSelecionado;

  @override
  void initState() {
    super.initState();
    _opcoesCampo = List.from(widget.opcoes);
    _valorSelecionado = widget.valorSelecionado;
  }

  String? _validar(T? valor) {
    if (widget.eObrigatorio && valor == null) {
      return 'Selecione uma opção';
    }
    return null;
  }

  Future<void> _navegarParaCadastro() async {
    final novoItem = await Navigator.pushNamed(context, widget.rotaCadastro);
    setState(() {
      _opcoesCampo = List.from(widget.opcoes);
      if (novoItem != null) {
        _valorSelecionado = novoItem as T;
        widget.onChanged?.call(_valorSelecionado); // Notifica o pai
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: DropdownButtonFormField<T>(
            decoration: InputDecoration(labelText: widget.rotulo),
            isExpanded: true,
            value: _valorSelecionado,
            validator: (value) => _validar(value),
            onChanged: (T? novoValor) {
              setState(() {
                _valorSelecionado = novoValor;
              });
              widget.onChanged?.call(novoValor);
            },
            items: [
              DropdownMenuItem<T>(
                value: null,
                child: Text(widget.textoPadrao),
              ),
              ..._opcoesCampo.map((op) => DropdownMenuItem<T>(
                    value: op,
                    child: Text(op.nome),
                  )),
            ],
          ),
        ),
        IconButton(
          onPressed: _navegarParaCadastro,
          icon: const Icon(Icons.add),
          tooltip: 'Adicionar novo',
        ),
        
      ],
    );
  }

}
