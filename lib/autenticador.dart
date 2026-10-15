import 'package:scametal/usuario.dart';

class Autenticador {
  static Future<Usuario?> login() async {
    return Usuario("Vin", "vin@scadrial.com");
  }

  static Future<Usuario?> recuperarUsuario() async {
    return Usuario("Vin", "vin@scadrial.com");
  }

  static Future<void> logout() async {
    //
  }
}