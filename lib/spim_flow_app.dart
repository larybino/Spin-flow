import 'package:flutter/material.dart';
import 'package:spin_flow/configuracoes/rotas.dart';
import 'package:spin_flow/widget/form_aluno.dart';
import 'package:spin_flow/widget/form_grupo_alunos.dart';
import 'package:spin_flow/widget/form_mix.dart';
import 'package:spin_flow/widget/form_artista_banda.dart';
import 'package:spin_flow/widget/form_bike.dart';
import 'package:spin_flow/widget/form_categoria_musica.dart';
import 'package:spin_flow/widget/form_fabricante.dart';
import 'package:spin_flow/widget/form_musica.dart';
import 'package:spin_flow/widget/form_sala.dart';
import 'package:spin_flow/widget/form_tipo_manutencao.dart';
import 'package:spin_flow/widget/form_turma.dart';
import 'package:spin_flow/widget/tela_dashboard_aluno.dart';
import 'package:spin_flow/widget/tela_dashboard_professora.dart';
import 'package:spin_flow/widget/tela_login.dart';

class SpinFlowApp extends StatelessWidget {
  const SpinFlowApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pinFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      initialRoute: Rotas.login,
      routes: {
        Rotas.login: (context) => const TelaLogin(),
        Rotas.dashboardAluno: (context) => const TelaDashboardAluno(),
        Rotas.dashboardProfessora: (context) => const TelaDashboardProfessora(),
        Rotas.cadastroCategoriaMusica: (context) => const FormCategoriaMusica(),
        Rotas.cadastroTipoManutencao: (context) => const FormTipoManutencaoTela(),
        Rotas.cadastroFabricante: (context) => const FormFabricante(),
        Rotas.cadastroBike: (context) => const FormBike(),
        Rotas.cadastroArtistaBanda: (context) => const FormArtistaBanda(),
        Rotas.cadastroMusica: (context) => const FormMusica(),
        Rotas.cadastroMix: (context) => const FormMix(),
        Rotas.cadastroSala: (context) => FormSala(),
        Rotas.cadastroTurma: (context) => const FormTurma(),
        Rotas.cadastroAluno: (context) => const FormAluno(),
        Rotas.cadastroGrupoAlunos: (context) => const FormGrupoAlunos(),
      },
    );
  }
}
