import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scametal/autenticador.dart';
import 'package:scametal/usuario.dart';

class TelaSugestoes extends StatefulWidget {
  final dynamic title;

  const TelaSugestoes({super.key, required this.title});

  @override
  State<TelaSugestoes> createState() => _TelaSugestoesState();
}

class _TelaSugestoesState extends State<TelaSugestoes> {
  static const _metais = [
    'Ferro',
    'Aço',
    'Estanho',
    'Peltre',
    'Zinco',
    'Latão',
    'Cobre',
    'Bronze',
    'Atium',
    'Malatium',
    'Ouro',
    'Electrum',
    'Alumínio',
    'Duralumínio',
  ];

  final _sugestoes = <Map<String, dynamic>>[];
  Usuario? _usuario;
  String _metal1 = 'Atium';
  String _metal2 = 'Estanho';
  double _percentual1 = 5;
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
    _carregarSugestoes();
  }

  Future<void> _carregarUsuario() async {
    final usuario = await Autenticador.recuperarUsuario();
    if (mounted) setState(() => _usuario = usuario);
  }

  Future<void> _carregarSugestoes() async {
    try {
      final json = await rootBundle.loadString('recursos/json/sugestoes.json');
      final dados = jsonDecode(json) as Map<String, dynamic>;

      if (!mounted) return;
      setState(() {
        _sugestoes.addAll(List<Map<String, dynamic>>.from(dados['sugestoes']));
        _carregando = false;
      });
    } catch (erro) {
      if (!mounted) return;
      setState(() {
        _erro = 'Não foi possível carregar as sugestões: $erro';
        _carregando = false;
      });
    }
  }

  void _enviarSugestao() {
    if (_usuario == null) return;
    if (_metal1 == _metal2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escolha dois metais diferentes.')),
      );
      return;
    }

    setState(() {
      _sugestoes.insert(0, {
        'metal1': _metal1,
        'percentual1': _percentual1.round(),
        'metal2': _metal2,
        'percentual2': 100 - _percentual1.round(),
        'usuario': _usuario!.nome,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 64, 16),
      appBar: AppBar(
        title: Text(widget.title.toString()),
        backgroundColor: Colors.white,
        foregroundColor: Color.fromARGB(255, 223, 64, 16),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Sugestões da comunidade',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (_carregando)
            const Center(child: CircularProgressIndicator())
          else if (_erro != null)
            Text(_erro!, style: const TextStyle(color: Colors.white))
          else
            ..._sugestoes.map(
              (sugestao) => Card(
                child: ListTile(
                  title: Text(
                    '${sugestao['percentual1']}% ${sugestao['metal1']} + '
                    '${sugestao['percentual2']}% ${sugestao['metal2']}',
                  ),
                  subtitle: Text('Sugerida por ${sugestao['usuario']}'),
                  subtitleTextStyle: TextStyle(color: Color.fromARGB(255, 223, 64, 16), fontWeight: FontWeight.w100),
                ),
              ),
            ),
          const SizedBox(height: 12),         
          if (_usuario == null)
            const Card(
              color: Colors.white60,
              child: ListTile(
                title: Text(
                  'Faça login para enviar uma sugestão',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          else
            _formulario(),
        ],
      ),
    );
  }

  Widget _formulario() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              'Sua sugestão de liga',
              style: TextStyle(color: Color.fromARGB(255, 223, 64, 16), fontWeight: FontWeight.bold),
            ),
            _campoMetal(_metal1, (metal) {
              if (metal != null) setState(() => _metal1 = metal);
            }),
            _campoMetal(_metal2, (metal) {
              if (metal != null) setState(() => _metal2 = metal);
            }),
            Text(
              '${_percentual1.round()}% $_metal1 + '
              '${100 - _percentual1.round()}% $_metal2',
            ),
            Slider(
              value: _percentual1,
              min: 1,
              max: 99,
              divisions: 98,
              activeColor: Color.fromARGB(255, 223, 64, 16),
              onChanged: (valor) => setState(() => _percentual1 = valor),
            ),
            ElevatedButton(
              onPressed: _enviarSugestao,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 223, 64, 16),
                foregroundColor: Colors.white,
              ),
              child: const Text('Enviar sugestão')
            ),
          ],
        ),
      ),
    );
  }

  Widget _campoMetal(String selecionado, ValueChanged<String?> aoMudar) {
    return DropdownButtonFormField<String>(
      value: selecionado,
      items: _metais
          .map((metal) => DropdownMenuItem(value: metal, child: Text(metal)))
          .toList(),
      onChanged: aoMudar,
    );
  }
}
