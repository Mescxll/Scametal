import 'package:scametal/usuario.dart';

class Autenticador {
  static Usuario? _usuarioAtual;

  static Future<Usuario?> login() async {
    _usuarioAtual ??= Usuario('Vin', 'vin@scadrial.com');
    return _usuarioAtual;
  }

  static Future<Usuario?> recuperarUsuario() async {
    return _usuarioAtual;
  }

  static Future<void> logout() async {
    _usuarioAtual = null;
  }
}