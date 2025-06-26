import 'package:flutter/material.dart';
import 'package:spin_flow/banco/mock/mock_video_aula.dart';
import 'package:spin_flow/dto/dto_video_aula.dart';
import 'package:spin_flow/configuracoes/rotas.dart';

class ListaVideoAula extends StatelessWidget {
  const ListaVideoAula({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vídeo-aulas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // No mock, não recarrega
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mock: lista estática')),
              );
            },
            tooltip: 'Recarregar',
          ),
        ],
      ),
      body: mockVideoAulas.isEmpty
          ? _widgetSemDados(context)
          : ListView.builder(
              itemCount: mockVideoAulas.length,
              itemBuilder: (context, index) => _itemLista(context, mockVideoAulas[index]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, Rotas.cadastroVideoAula),
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
            onPressed: () => Navigator.pushNamed(context, Rotas.cadastroVideoAula),
            icon: const Icon(Icons.add),
            label: const Text('Adicionar Vídeo-aula'),
          ),
        ],
      ),
    );
  }

  Widget _itemLista(BuildContext context, DTOVideoAula videoAula) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(
          videoAula.ativo ? Icons.play_circle_fill : Icons.pause_circle_filled,
          color: videoAula.ativo ? Colors.green : Colors.grey,
        ),
        title: Text(videoAula.nome),
        subtitle: Text(videoAula.linkVideo ?? 'Sem link'),
        trailing: IconButton(
          icon: const Icon(Icons.open_in_new),
          tooltip: 'Abrir link',
          onPressed: videoAula.linkVideo != null && videoAula.linkVideo!.isNotEmpty
              ? () => _abrirLink(context, videoAula.linkVideo!)
              : null,
        ),
        onTap: () => Navigator.pushNamed(
          context,
          Rotas.cadastroVideoAula,
          arguments: videoAula,
        ),
      ),
    );
  }

  void _abrirLink(BuildContext context, String url) async {
    // Para abrir links, normalmente se usa url_launcher, mas aqui só mostra um SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Abrir link: $url')),
    );
  }
} 