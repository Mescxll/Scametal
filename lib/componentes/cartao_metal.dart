import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scametal/componentes/detalhes_metal.dart';
//import 'package:scametal/gerenciador_estado.dart';

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
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 8),
              Text(
                'Poder alomântico: '
                '${metal["metal"]["poderAlomantico"]}\n\n'
                'Poder feruquêmico: '
                '${metal["metal"]["poderFeruquemico"]}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
