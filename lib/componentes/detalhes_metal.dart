import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scametal/autenticador.dart';
import 'package:scametal/usuario.dart';
import 'package:scametal/componentes/cartao_comentario.dart';

class TelaDetalhesMetal extends StatefulWidget {
  final dynamic metal;
  
  const TelaDetalhesMetal({super.key, required this.metal});

  @override
  State<TelaDetalhesMetal> createState() => _TelaDetalhesMetalState();
}

class _TelaDetalhesMetalState extends State<TelaDetalhesMetal> {
  final TextEditingController _comentarioController = TextEditingController();
  Usuario? _usuarioLogado;
  List<Map<String, dynamic>> _comentarios = [];
  bool _carregandoComentarios = true;
  String? _erroComentarios;

  @override
  void initState() {
    super.initState();
    _carregarComentarios();
    _carregarUsuarioLogado();
  }

  Future<void> _carregarUsuarioLogado() async {
    final usuario = await Autenticador.recuperarUsuario();

    if (!mounted) return;

    setState(() {
      _usuarioLogado = usuario;
    });
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _carregarComentarios() async {
    try {
      final conteudo = await rootBundle.loadString(
        'recursos/json/comentarios.json',
      );
      final dados = jsonDecode(conteudo) as Map<String, dynamic>;
      final comentarios =
          (dados['comentarios'] as List).cast<Map<String, dynamic>>();

      if (!mounted) return;

      setState(() {
        _comentarios = comentarios
            .where((comentario) => comentario['metalId'] == widget.metal['id'])
            .toList();
        _carregandoComentarios = false;
      });
    } catch (erro) {
      if (!mounted) return;

      setState(() {
        _erroComentarios = 'Não foi possível carregar os comentários: $erro';
        _carregandoComentarios = false;
      });
    }
  }

  Future<void> _inserirComentario() async {
    final conteudo = _comentarioController.text.trim();

    if (conteudo.isEmpty) return;

    final Usuario? usuario = await Autenticador.recuperarUsuario();

    if (!mounted) return;

    if (usuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faça login para comentar.')),
      );
      return;
    }

    setState(() {
      _comentarios.insert(0, {
        'metalId': widget.metal['id'],
        'user': {
          'email': usuario.email,
          'name': usuario.nome,
        },
        'datetime': DateTime.now().toIso8601String(),
        'content': conteudo,
      });
      _comentarioController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final arquivoImagem = widget.metal['metal']['imagem']['arquivo'] as String;
    final arquivoIcon = arquivoImagem.replaceFirst('.jpeg', '_icon.svg');

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 64, 16),
      appBar: AppBar(
        title: Text(widget.metal['metal']['nome'].toString()),
        foregroundColor: const Color.fromARGB(255, 223, 64, 16),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 28,
          color: const Color.fromARGB(255, 223, 64, 16),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const SizedBox(height: 18),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'recursos/imagens/${widget.metal['metal']['imagem']['arquivo']}',
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              SvgPicture.asset(
                'recursos/imagens/$arquivoIcon',
                width: 45,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.metal['metal']['nome'].toString(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ),
              const SizedBox(width: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.metal['curtidas'].toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          _itemDetalhe('Categoria', widget.metal['metal']['categoria'].toString()),
          _itemDetalhe(
            'Nomeclatura alomântica',
            widget.metal['metal']['tipoAlomantico'].toString(),
          ),
          _itemDetalhe(
            'Poder alomântico',
            widget.metal['metal']['poderAlomantico'].toString(),
          ),
          _itemDetalhe(
            'Poder feruquêmico',
            widget.metal['metal']['poderFeruquemico'].toString(),
          ),
          if (widget.metal['metal']['possuiLiga'] == true &&
              widget.metal['metal']['liga'] is List)
            _itemDetalhe(
              'Liga',
              (widget.metal['metal']['liga'] as List).join(', '),
            ),
          const SizedBox(height: 55),
          const Text(
            'Comentários',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _comentarioController,
            maxLines: 1,
            style: const TextStyle(
              color: Color.fromARGB(255, 223, 64, 16),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hint: Row(
                children: const [
                  Icon(
                    Icons.comment_outlined,
                    color: Color.fromARGB(255, 223, 64, 16),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Escreva um comentário',
                    style: TextStyle(
                      color: Color.fromARGB(255, 223, 64, 16),
                    ),
                  ),
                ],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 8), 
          ElevatedButton(
            onPressed: _carregandoComentarios ? null : _inserirComentario,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color.fromARGB(255, 223, 64, 16),
              elevation: 0,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Enviar comentário'),
          ), 
          const SizedBox(height: 25),
                    if (_erroComentarios != null)
            Text(
              _erroComentarios!,
              style: const TextStyle(color: Colors.white),
            ),
          if (_carregandoComentarios)
            const Center(child: CircularProgressIndicator())
          else
            ..._comentarios.map(
            (comentario) => CartaoComentario(
              comentario: comentario,
              comentarioDoUsuario:
                  comentario['user']['email'] == _usuarioLogado?.email,
            ),
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
            color: Color.fromARGB(255, 223, 64, 16),
          ),
        ),
        subtitle: Text(
          valor,
          style: const TextStyle(
            color: Color.fromARGB(255, 223, 64, 16),
          ),
        ),
      ),
    );
  }
}