import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaDetalhesMetal extends StatelessWidget {
  final dynamic metal;

  const TelaDetalhesMetal({super.key, required this.metal});

  @override
  Widget build(BuildContext context) {
    final arquivoImagem = metal["metal"]["imagem"]["arquivo"] as String;
    final arquivoIcon = arquivoImagem.replaceFirst('.jpeg', '_icon.svg');

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 64, 16),
      appBar: AppBar(
        title: Text(metal['metal']['nome'].toString()),
        foregroundColor: const Color.fromARGB(255, 223, 64, 16),
        titleTextStyle: GoogleFonts.poppins(fontSize: 28, color: Color.fromARGB(255, 223, 64, 16)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 18),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'recursos/imagens/${metal['metal']['imagem']['arquivo']}',
                height: 250,
                fit: BoxFit.cover, 
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(children: [
            SvgPicture.asset(
              'recursos/imagens/$arquivoIcon',
              width: 45,
              color: Colors.white,
            ),
            Text(
              metal['metal']['nome'].toString(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
        ]),
          const SizedBox(height: 18),
          _itemDetalhe(
            'Categoria',
            metal['metal']['categoria'].toString(),
          ),
          _itemDetalhe(
            'Nomeclatura alomântica',
            metal['metal']['tipoAlomantico'].toString(),
          ),
          _itemDetalhe(
            'Poder alomântico',
            metal['metal']['poderAlomantico'].toString(),
          ),
          _itemDetalhe(
            'Poder feruquêmico',
            metal['metal']['poderFeruquemico'].toString(),
          ),
          if (metal['metal']['possuiLiga'] == true &&
              metal['metal']['liga'] is List)
            _itemDetalhe(
              'Liga',
              (metal['metal']['liga'] as List).join(', '),
            ),
        ],
      ),
    );
  }

  Widget _itemDetalhe(String titulo, String valor) {
    return Card(
      color: Colors.white,
      child: ListTile(
        title: Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold, 
            color: Color.fromARGB(255, 223, 64, 16)
          )
        ),
        subtitle: Text(
          valor, 
          style: TextStyle(color: Color.fromARGB(255, 223, 64, 16)),),
      ),
    );
  }
}