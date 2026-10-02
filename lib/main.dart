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

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.45,
      ),
      itemCount: estadoApp.metais.length,
      itemBuilder: (context, index) =>
          CartaoProduto(metal: estadoApp.metais[index]),
    );
  },
),
    );
  }
}
