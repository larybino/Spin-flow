import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spin_flow/dto/dto_sala.dart';

class FormSala extends StatefulWidget {
  const FormSala({super.key});

  @override
  State<FormSala> createState() => _FormSalaState();
}

class _FormSalaState extends State<FormSala> {
  final _formKey = GlobalKey<FormState>();
  
  // Campos do formulário
  String? _nome;
  String? _numBikes;
  String? _numFilas;
  String? _limiteBikes;

  int numBikes = 0;
  int numFilas = 0;
  int limiteBikesPorFila = 0;

  /// gradeBikes[fila][bike] = true se a bike estiver ocupando aquele espaço
  List<List<bool>> gradeBikes = [];

  /// Define deslocamento horizontal da fila para efeito zig-zag
  double deslocamentoFila(int fila) {
    // 0 (fila da professora) deslocada para direita (espaço vazio na esquerda)
    // 1 deslocada para esquerda (encaixa no vazio da anterior)
    // repete
    if (fila % 2 == 0) {
      return 40; // desloca para direita 40 pixels
    } else {
      return 0; // alinhada esquerda (sem deslocamento)
    }
  }

  /// Cria a grade inicializada para o número de filas e limite de bikes por fila
  /// Coloca as bikes na grade proporcionalmente conforme numBikes
  void criarGrade() {
    gradeBikes = List.generate(
      numFilas + 1, // +1 fila da professora (fila 0)
      (_) => List.generate(limiteBikesPorFila, (_) => false),
    );

    // Preencher a bike da professora na fila 0 meio da fila
    int bikeProf = limiteBikesPorFila ~/ 2;
    gradeBikes[0][bikeProf] = true;

    // Calcula as bikes restantes para distribuir nas outras filas
    int bikesRestantes = numBikes - 1;
    if (bikesRestantes < 0) bikesRestantes = 0;

    // Distribui nas outras filas, da primeira (fila 1) até a última (fila numFilas)
    for (int fila = 1; fila <= numFilas && bikesRestantes > 0; fila++) {
      for (int bike = 0; bike < limiteBikesPorFila && bikesRestantes > 0; bike++) {
        gradeBikes[fila][bike] = true;
        bikesRestantes--;
      }
    }

    setState(() {});
  }

  /// Mover bike de uma posição para outra
  void moverBike(int filaDestino, int bikeDestino, int filaOrigem, int bikeOrigem) {
    setState(() {
      gradeBikes[filaOrigem][bikeOrigem] = false;
      gradeBikes[filaDestino][bikeDestino] = true;
    });
  }

  void _limparFormulario() {
    setState(() {
      _nome = null;
      _numBikes = null;
      _numFilas = null;
      _limiteBikes = null;
      numBikes = 0;
      numFilas = 0;
      limiteBikesPorFila = 0;
      gradeBikes = [];
    });
    _formKey.currentState?.reset();
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      if (numBikes > limiteBikesPorFila * numFilas + 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Número de bikes excede capacidade total')),
        );
        return;
      }

      // Criar DTO
      final dto = DTOSala(
        nome: _nome ?? '',
        numeroBikes: numBikes,
        numeroFilas: numFilas,
        limiteBikesPorFila: limiteBikesPorFila,
        gradeBikes: gradeBikes,
      );

      // Mostrar dados em dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sala Criada'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nome: ${dto.nome}'),
                Text('Número de Bikes: ${dto.numeroBikes}'),
                Text('Número de Filas: ${dto.numeroFilas}'),
                Text('Limite de Bikes por Fila: ${dto.limiteBikesPorFila}'),
                Text('Capacidade Total: ${dto.numeroFilas * dto.limiteBikesPorFila + 1}'),
                const SizedBox(height: 8),
                Text('Grade configurada com ${dto.gradeBikes.length} filas'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        ),
      );

      // SnackBar de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sala salva com sucesso! ${dto.nome}')),
      );

      // Limpar formulário
      _limparFormulario();
    }
  }

  Widget _buildCampos() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            decoration: const InputDecoration(labelText: 'Nome da Sala'),
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'Informe o nome' : null,
            onChanged: (value) => _nome = value,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: TextFormField(
            decoration: const InputDecoration(labelText: 'Nº Bikes'),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) return 'Informe Nº de Bikes';
              final n = int.tryParse(value);
              if (n == null || n < 1) return 'Número positivo obrigatório';
              return null;
            },
            onChanged: (value) {
              _numBikes = value;
              _atualizarNumeros();
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: TextFormField(
            decoration: const InputDecoration(labelText: 'Nº Filas'),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) return 'Informe Nº de Filas';
              final n = int.tryParse(value);
              if (n == null || n < 1 || n >= 100) return '1 a 99';
              return null;
            },
            onChanged: (value) {
              _numFilas = value;
              _atualizarNumeros();
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: TextFormField(
            decoration: const InputDecoration(labelText: 'Bikes/Fila'),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) return 'Informe limite bikes';
              final n = int.tryParse(value);
              if (n == null || n < 1 || n >= 100) return '1 a 99';
              return null;
            },
            onChanged: (value) {
              _limiteBikes = value;
              _atualizarNumeros();
            },
          ),
        ),
      ],
    );
  }

  void _atualizarNumeros() {
    final nBikes = int.tryParse(_numBikes ?? '0') ?? 0;
    final nFilas = int.tryParse(_numFilas ?? '0') ?? 0;
    final limiteBikes = int.tryParse(_limiteBikes ?? '0') ?? 0;

    setState(() {
      numBikes = nBikes;
      numFilas = nFilas;
      limiteBikesPorFila = limiteBikes;
      if (numFilas > 0 && limiteBikesPorFila > 0 && numBikes > 0) {
        criarGrade();
      } else {
        gradeBikes = [];
      }
    });
  }

  Widget _buildGrade() {
    if (gradeBikes.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Grade da Sala (arraste para mover bikes):',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 60.0 * gradeBikes.length,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: gradeBikes.length,
            itemBuilder: (context, fila) {
              return Transform.translate(
                offset: Offset(deslocamentoFila(fila), 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(limiteBikesPorFila, (bike) {
                    bool existeBike = gradeBikes[fila][bike];

                    Color corBase = Colors.grey[300]!;
                    Color corBike = existeBike ? Colors.blue : corBase;

                    return DragTarget<Map<String, int>>(
                      onWillAcceptWithDetails: (details) {
                        final data = details.data;
                        // Permite mover para qualquer fila, inclusive fila 0,
                        // desde que o destino seja diferente da origem e vazio
                        return (fila != data['fila'] || bike != data['bike']) &&
                            gradeBikes[fila][bike] == false;
                      },
                      onAcceptWithDetails: (details) {
                        final data = details.data;
                        moverBike(fila, bike, data['fila']!, data['bike']!);
                      },
                      builder: (context, candidateData, rejectedData) {
                        bool podeMoverAqui = candidateData.isNotEmpty;
                        Color corFinal = podeMoverAqui ? Colors.green[300]! : corBike;

                        return existeBike
                            ? LongPressDraggable<Map<String, int>>(
                                data: {'fila': fila, 'bike': bike},
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withValues(alpha: 0.7),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.black26),
                                    ),
                                    child: Center(
                                      child: fila == 0 && bike == (limiteBikesPorFila ~/ 2)
                                          ? const Icon(Icons.star, color: Colors.yellow)
                                          : const Icon(Icons.directions_bike, color: Colors.white),
                                    ),
                                  ),
                                ),
                                childWhenDragging: Container(
                                  width: 40,
                                  height: 40,
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: corBase,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                ),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: corFinal,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black54),
                                  ),
                                  child: Center(
                                    child: fila == 0 && bike == (limiteBikesPorFila ~/ 2)
                                        ? const Icon(Icons.star, color: Colors.yellow)
                                        : const Icon(Icons.directions_bike, color: Colors.white),
                                  ),
                                ),
                              )
                            : Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: corFinal,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.black26),
                                ),
                              );
                      },
                    );
                  }),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Sala de Spinning')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildCampos(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (numBikes > limiteBikesPorFila * numFilas + 1) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Número de bikes excede capacidade total')),
                            );
                            return;
                          }
                          criarGrade();
                          FocusScope.of(context).unfocus();
                        }
                      },
                      child: const Text('Gerar Grade'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _salvar,
                      child: const Text('Salvar Sala'),
                    ),
                  ),
                ],
              ),
              Expanded(child: SingleChildScrollView(child: _buildGrade())),
            ],
          ),
        ),
      ),
    );
  }
}
