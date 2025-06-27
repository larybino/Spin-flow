import 'package:flutter/material.dart';
import 'package:spin_flow/dto/dto_bike.dart';
import 'package:spin_flow/dto/dto_fabricante.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_data.dart';
import 'package:spin_flow/widget/componentes/campos/selecao_unica/campo_opcoes.dart';
import 'package:spin_flow/widget/componentes/campos/comum/campo_texto.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_bike.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_fabricante.dart';

class FormBike extends StatefulWidget {
  const FormBike({super.key});

  @override
  State<FormBike> createState() => _FormBikeState();
}

class _FormBikeState extends State<FormBike> {
  final _formKey = GlobalKey<FormState>();

  final DAOBike _daoBike = DAOBike();
  final DAOFabricante _daoFabricante = DAOFabricante();
  // Campos do formulário
  final TextEditingController _nomeControlador = TextEditingController();
  final TextEditingController _numeroSerieControlador = TextEditingController();
  DTOFabricante? _fabricanteSelecionado;
  DateTime? _dataCadastro;
  bool _ativa = true;
  int? _id;

  List<DTOFabricante> _fabricantes = [];
  bool _carregandoFabricantes = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarDados();
    });
  }

  Future<void> _carregarDados() async {
    await _carregarFabricantesDoBanco();
    _carregarDadosDaBikeParaEdicao();
  }

  Future<void> _carregarFabricantesDoBanco() async {
    try {
      final fabricantesDoBanco = await _daoFabricante.buscarTodos();
      if (mounted) {
        setState(() {
          _fabricantes = fabricantesDoBanco;
          _carregandoFabricantes = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _carregandoFabricantes = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar fabricantes: $e')),
        );
      }
    }
  }

  void _carregarDadosDaBikeParaEdicao() {
    final argumento = ModalRoute.of(context)?.settings.arguments;
    if (argumento != null && argumento is DTOBike) {
      final bikeParaEditar = argumento;
      setState(() {
        _id = bikeParaEditar.id;
        _nomeControlador.text = bikeParaEditar.nome;
        _numeroSerieControlador.text = bikeParaEditar.numeroSerie ?? '';
        _dataCadastro = bikeParaEditar.dataCadastro;
        _ativa = bikeParaEditar.ativa;
        _fabricanteSelecionado = _fabricantes.firstWhere(
          (f) => f.id == bikeParaEditar.fabricante.id,
          orElse: () => _fabricantes.first, 
        );
      });
    }
  }

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      if (_fabricanteSelecionado == null || _dataCadastro == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preencha todos os campos obrigatórios'),
          ),
        );
        return;
      }

      final dto = DTOBike(
        id: _id, 
        nome: _nomeControlador.text,
        numeroSerie: _numeroSerieControlador.text,
        fabricante: _fabricanteSelecionado!,
        dataCadastro: _dataCadastro!,
        ativa: _ativa,
      );

      try {
        await _daoBike.salvar(dto); 
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bike "${dto.nome}" salva com sucesso!')),
        );
        Navigator.pushReplacementNamed(context, Rotas.listaBikes);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erro ao salvar bike: $e')));
        }
      }
    }
  }

  @override
  void dispose() {
    _nomeControlador.dispose();
    _numeroSerieControlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_id == null ? 'Cadastro de Bike' : 'Editar Bike')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CampoTexto(
                controle: _nomeControlador,
                rotulo: 'Nome da Bike',
                dica: 'Nome identificador da bike',
                eObrigatorio: true,
              ),
              const SizedBox(height: 16),
              CampoTexto(
                controle: _numeroSerieControlador,
                rotulo: 'Número de Série',
                dica: 'Número de série da bike',
                eObrigatorio: false,
              ),
              const SizedBox(height: 16),
              _carregandoFabricantes 
                ? const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()))
                : CampoOpcoes<DTOFabricante>(
                opcoes: _fabricantes,
                rotulo: 'Fabricante',
                textoPadrao: 'Selecione um fabricante',
                rotaCadastro: Rotas.cadastroFabricante,
                aoAlterar: (fabricante) =>
                    setState(() => _fabricanteSelecionado = fabricante),
              ),
              const SizedBox(height: 16),
              CampoData(
                rotulo: 'Data de Cadastro',
                valor: _dataCadastro,
                eObrigatorio: true,
                aoAlterar: (data) {
                  setState(() {
                    _dataCadastro = data;
                  });
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Ativa'),
                value: _ativa,
                onChanged: (valor) {
                  setState(() {
                    _ativa = valor;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
              ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}
