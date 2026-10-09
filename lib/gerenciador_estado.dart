import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum EmExibicao { telaMetais, telaDetalhes, telaSugestoes }

class GerenciadorEstado extends ChangeNotifier {
  EmExibicao _exibicao = EmExibicao.telaMetais;
  EmExibicao get exibicao => _exibicao;

  int id = -1;
  int get idMetal => id;

  List<Map<String, dynamic>> _metais = [];
  List<Map<String, dynamic>> get metais => _metais;
  bool carregando = true;
  String? erro;

  Future<void> carregarMetais() async {
    final conteudo = await rootBundle.loadString('recursos/json/metais.json');
    _metais = List<Map<String, dynamic>>.from(jsonDecode(conteudo) as List);  
    carregando = false;
    notifyListeners();
  }

  void exibirMetais() {
    _exibicao = EmExibicao.telaMetais;
    notifyListeners();
  }

  void exibirDetalhes(int id) {
    _exibicao = EmExibicao.telaDetalhes;
     id = id;
    notifyListeners();
  }

  void exibirSugestoes() {
    _exibicao = EmExibicao.telaSugestoes;
    notifyListeners();
  }
}

late GerenciadorEstado estadoApp;