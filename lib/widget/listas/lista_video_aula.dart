import 'package:flutter/material.dart';
import 'package:spin_flow/banco/sqlite/dao/dao_video_aula.dart';
import 'package:spin_flow/dto/dto_video_aula.dart';
import 'package:spin_flow/configuracoes/rotas.dart';


class ListaVideoAula extends StatefulWidget {
  const ListaVideoAula({super.key});

  @override
  State<ListaVideoAula> createState() => _ListaVideoAulaState();
}

class _ListaVideoAulaState extends State<ListaVideoAula> {
  final DAOVideoAula _dao = DAOVideoAula();

  void _recarregarLista() {
    setState(() {});
  }

  Future<void> _navegarParaFormulario([DTOVideoAula? videoAula]) async {
    await Navigator.pushNamed(
      context,
      Rotas.cadastroVideoAula,
      arguments: videoAula,
    );
    _recarregarLista();
  }

  void _excluirVideoAula(int id) {
    _dao.excluir(id).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vídeo-aula excluída com sucesso!')),
      );
      _recarregarLista();
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir: $e')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vídeo-aulas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _recarregarLista, // Agora o botão funciona!
            tooltip: 'Recarregar',
          ),
        ],
      ),
      body: FutureBuilder<List<DTOVideoAula>>(
        future: _dao.listar(), // O Future que o builder vai "escutar"
        builder: (context, snapshot) {
          // 1. Enquanto os dados estão carregando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. Se ocorreu um erro na busca
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
          }
          // 3. Se os dados foram carregados, mas a lista está vazia
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _widgetSemDados(context);
          }

          // 4. Se tudo deu certo, exibe a lista de dados reais
          final videoAulas = snapshot.data!;
          return ListView.builder(
            itemCount: videoAulas.length,
            itemBuilder: (context, index) => _itemLista(context, videoAulas[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navegarParaFormulario(), 
        tooltip: 'Adicionar Vídeo-aula',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _widgetSemDados(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.ondemand_video, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Nenhuma vídeo-aula cadastrada', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _navegarParaFormulario(),
            icon: const Icon(Icons.add),
            label: const Text('Adicionar Vídeo-aula'),
          ),
        ],
      ),
    );
  }

  Widget _itemLista(BuildContext context, DTOVideoAula videoAula) {
    return Dismissible(
      key: Key(videoAula.id.toString()), // Chave única para identificar o item
      direction: DismissDirection.endToStart, // Deslizar da direita para a esquerda
      onDismissed: (direction) {
        _excluirVideoAula(videoAula.id!); // Chama a função de exclusão
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(
          videoAula.ativo ? Icons.play_circle_fill : Icons.pause_circle_filled,
          color: videoAula.ativo ? Colors.green : Colors.grey,
        ),
        title: Text(videoAula.nome),
          subtitle: Text(videoAula.linkVideo?.isNotEmpty == true ? videoAula.linkVideo! : 'Sem link'),
          trailing: IconButton(
            icon: const Icon(Icons.open_in_new),
            tooltip: 'Abrir link',
            onPressed: videoAula.linkVideo != null && videoAula.linkVideo!.isNotEmpty
                ? () => _abrirLink(context, videoAula.linkVideo!)
                : null,
          ),
          onTap: () => _navegarParaFormulario(videoAula), 
        ),
      ),
    );
  }

  void _abrirLink(BuildContext context, String url) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Abrir link: $url')),
    );
  }
} 