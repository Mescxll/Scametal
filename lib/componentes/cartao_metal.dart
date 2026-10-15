import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:scametal/autenticador.dart';
import 'package:scametal/componentes/area_sugestoes.dart';
import 'package:scametal/componentes/detalhes_metal.dart';
import 'package:scametal/gerenciador_estado.dart';
import 'package:scametal/usuario.dart';

class TelaMetais extends StatefulWidget {
  const TelaMetais({super.key});

  @override
  State<TelaMetais> createState() => _TelaMetaisState();
}

class _TelaMetaisState extends State<TelaMetais> {
  Usuario? _usuario;

  @override
  void initState() {
    super.initState();
    estadoApp.carregarMetais();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    final usuario = await Autenticador.recuperarUsuario();
    if (!mounted) return;

    setState(() {
      _usuario = usuario;
    });
  }

  Future<void> _alternarLogin() async {
    if (_usuario == null) {
      final usuario = await Autenticador.login();
      if (!mounted) return;

      setState(() {
        _usuario = usuario;
      });
    } else {
      await Autenticador.logout();
      if (!mounted) return;

      setState(() {
        _usuario = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 223, 64, 16),
        title: const Text('Scametal'),
        titleTextStyle: GoogleFonts.poppins(fontSize: 28, color: Colors.white),
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset('recursos/imagens/area_ligas_icon.png'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const TelaSugestoes(title: 'Sugestões'),
              ),
            );
          },
        ),
        actions: [
          TextButton.icon(
            onPressed: _alternarLogin,
            icon: Icon(
              _usuario == null ? Icons.login : Icons.logout,
              color: Colors.white,
            ),
            label: Text(
              _usuario == null ? 'Entrar' : 'Sair',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: estadoApp,
        builder: (context, _) {
          if (estadoApp.carregando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (estadoApp.erro != null) {
            return Center(child: Text(estadoApp.erro!));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              const espacamento = 8.0;
              
              final colunas = constraints.maxWidth < 600
                  ? 2
                  : constraints.maxWidth < 900
                  ? 3
                  : 4;
              final metais = estadoApp.metais;
              final quantidadeLinhas = (metais.length + colunas - 1) ~/ colunas;

              return ListView.builder(
                padding: const EdgeInsets.all(espacamento),
                itemCount: quantidadeLinhas,
                itemBuilder: (context, indiceLinha) {
                  final primeiroIndice = indiceLinha * colunas;
                  final restantes = metais.length - primeiroIndice;
                  final quantidadeNaLinha = restantes < colunas
                      ? restantes
                      : colunas;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: espacamento),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(quantidadeNaLinha, (
                          indiceColuna,
                        ) {
                          final indiceMetal = primeiroIndice + indiceColuna;

                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: indiceColuna == quantidadeNaLinha - 1
                                    ? 0
                                    : espacamento,
                              ),
                              child: CartaoProduto(metal: metais[indiceMetal]),
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class CartaoProduto extends StatelessWidget {
  final dynamic metal;

  const CartaoProduto({super.key, required this.metal});

  @override
  Widget build(BuildContext context) {
    final arquivoImagem = metal["metal"]["imagem"]["arquivo"] as String;
    final arquivoIcon = arquivoImagem.replaceFirst('.jpeg', '_icon.svg');

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => TelaDetalhesMetal(metal: metal),
          ),
        );
      },
      child: Card(
        color: const Color.fromARGB(255, 234, 81, 34),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'recursos/imagens/${metal["metal"]["imagem"]["arquivo"]}',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                metal["metal"]["categoria"].toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  SvgPicture.asset(
                    'recursos/imagens/$arquivoIcon',
                    width: 32,
                    height: 32,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      metal["metal"]["nome"].toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'Poder alomântico: ${metal["metal"]["poderAlomantico"]}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 15),
              Text(
                'Poder feruquêmico: ${metal["metal"]["poderFeruquemico"]}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 17),
            ],
          ),
        ),
      ),
    );
  }
}
