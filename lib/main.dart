import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scametal/componentes/cartao_metal.dart';
import 'package:scametal/gerenciador_estado.dart';

void main() {
  estadoApp = GerenciadorEstado();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
        theme: ThemeData.light().copyWith(
          textTheme: ThemeData.light().textTheme.apply(
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
      home: const MyHomePage(title: 'Scametal'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    estadoApp.carregarMetais();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 223, 64, 16),
        title: Text(widget.title),
        titleTextStyle: GoogleFonts.poppins(fontSize: 28, color: Colors.white),
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset('recursos/imagens/area_ligas_icon.png'),
          onPressed: () {
            print("Botão clicado.");
          },
        ),
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

            final colunas = constraints.maxWidth < 600 ? 2 : constraints.maxWidth < 900 ? 3 : 4;

            final metais = estadoApp.metais;
            final quantidadeLinhas = (metais.length + colunas - 1) ~/ colunas;

            return ListView.builder(
              padding: const EdgeInsets.all(espacamento),
              itemCount: quantidadeLinhas,
              itemBuilder: (context, indiceLinha) {
                final primeiroIndice = indiceLinha * colunas;
                final restantes = metais.length - primeiroIndice;
                final quantidadeNaLinha = restantes < colunas ? restantes : colunas;

                return Padding(
                  padding: const EdgeInsets.only(bottom: espacamento),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(quantidadeNaLinha, (indiceColuna) {
                        final indiceMetal = primeiroIndice + indiceColuna;

                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: indiceColuna == quantidadeNaLinha - 1 ? 0 : espacamento),
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
