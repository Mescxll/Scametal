import 'package:flutter/material.dart';

class CartaoComentario extends StatelessWidget {
  final dynamic comentario;
  final bool comentarioDoUsuario;

  const CartaoComentario({
    super.key,
    required this.comentario,
    required this.comentarioDoUsuario,
  });

  @override
  Widget build(BuildContext context) {
    final data = DateTime.parse(comentario['datetime']).toLocal();
    final dataFormatada =
        '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year} ${data.hour.toString().padLeft(2, '0')}:'
        '${data.minute.toString().padLeft(2, '0')}';

    return Card(
      color: comentarioDoUsuario ? const Color.fromARGB(146, 244, 147, 118) : Colors.white54,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comentario['content'],
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(dataFormatada, style: const TextStyle(fontSize: 12, color: Colors.white)),
                const SizedBox(width: 10),
                Text(
                  comentario['user']['name'],
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}