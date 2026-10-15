import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scametal/gerenciador_estado.dart';

import 'package:scametal/componentes/cartao_metal.dart';


void main() {
  estadoApp = GerenciadorEstado();
  runApp(const Scametal());
}

class Scametal extends StatelessWidget {
  const Scametal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scametal',
      theme: ThemeData.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
      ),
      home: const TelaMetais(),
    );
  }
}
