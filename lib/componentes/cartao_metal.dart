import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:scametal/gerenciador_estado.dart';

class CartaoProduto extends StatelessWidget {
  final dynamic metal;

  const CartaoProduto({super.key, required this.metal});

  @override
  Widget build(BuildContext context) {
    final arquivoImagem = metal["metal"]["imagem"]["arquivo"] as String;
    final arquivoIcon = arquivoImagem.replaceFirst('.jpeg', '_icon.svg');
    
    return GestureDetector(
      //onTap: () => {estadoApp.exibirDetalhes(produto["_id"])},
      child: Card(
        color: const Color.fromARGB(255, 234, 81, 34),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 180,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'recursos/imagens/${metal["metal"]["imagem"]["arquivo"]}',
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    metal["metal"]["categoria"],
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [            
                  SvgPicture.asset(
                    'recursos/imagens/$arquivoIcon',
                    width: 32,
                    color: Colors.white,
                  ),         
                  Text(
                    " ${metal["metal"]["nome"]}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ]
              ) 
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                "Poder alomântico: ${metal["metal"]["poderAlomantico"]}\n\nPoder Feruquêmico: ${metal["metal"]["poderFeruquemico"]}",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
