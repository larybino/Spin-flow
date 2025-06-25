import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto.dart';

class CampoBuscaOpcoes<T extends DTO> extends StatefulWidget {
  final List<T> opcoes;
  final T? valorSelecionado;
  final bool eObrigatorio;
  final String textoPadrao;
  final String rotulo;
  final void Function(T?)? onChanged;
  final String rotaCadastro;

  const CampoBuscaOpcoes({
    super.key,
    required this.opcoes,
    this.valorSelecionado,
    this.eObrigatorio = true,
    this.textoPadrao = 'Digite para buscar...',
    required this.rotulo,
    this.onChanged,
    required this.rotaCadastro,
  });

  @override
  State<CampoBuscaOpcoes<T>> createState() => _CampoBuscaOpcoesState<T>();
}

class _CampoBuscaOpcoesState<T extends DTO> extends State<CampoBuscaOpcoes<T>> {
  late List<T> _opcoesFiltradas;
  T? _selecionado;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _exibirSugestoes = false;

  @override
  void initState() {
    super.initState();
    _opcoesFiltradas = List.from(widget.opcoes);
    _selecionado = widget.valorSelecionado;
    if (_selecionado != null) {
      _controller.text = _selecionado!.nome;
    }
  }

  void _filtrar(String texto) {
    setState(() {
      _opcoesFiltradas = widget.opcoes
          .where((item) => item.nome.toLowerCase().contains(texto.toLowerCase()))
          .toList();
      _exibirSugestoes = true;
    });
  }

  Future<void> _navegarParaCadastro() async {
    final novoItem = await Navigator.pushNamed(context, widget.rotaCadastro);
    if (novoItem != null && novoItem is T) {
      setState(() {
        widget.opcoes.add(novoItem);
        _controller.text = novoItem.nome;
        _selecionado = novoItem;
        widget.onChanged?.call(_selecionado);
        _exibirSugestoes = false;
      });
    }
  }

  String? _validar(String? texto) {
    if (widget.eObrigatorio && (_selecionado == null)) {
      return 'Selecione uma opção';
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
            Expanded(
              child: TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  labelText: widget.rotulo,
                ),
                validator: _validar,
                onChanged: _filtrar,
                onTap: () => setState(() => _exibirSugestoes = true),
              ),
            ),
            IconButton(
              onPressed: _navegarParaCadastro,
              icon: const Icon(Icons.add),
              tooltip: 'Adicionar novo',
            ),
          ],
        ),
        if (_exibirSugestoes && _opcoesFiltradas.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView(
              shrinkWrap: true,
              children: _opcoesFiltradas.map((item) {
                return ListTile(
                  title: Text(item.nome),
                  onTap: () {
                    setState(() {
                      _controller.text = item.nome;
                      _selecionado = item;
                      _exibirSugestoes = false;
                    });
                    widget.onChanged?.call(item);

                    // Seleciona o texto inteiro após um pequeno delay
                    Future.delayed(const Duration(milliseconds: 100), () {
                      _focusNode.requestFocus();
                      _controller.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _controller.text.length,
                      );
                    });
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
