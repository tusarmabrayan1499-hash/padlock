import 'package:flutter/foundation.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  Usuario? _usuario;
  bool _cargando = true;

  Usuario? get usuario => _usuario;
  bool get estaAutenticado => _usuario != null;
  bool get cargando => _cargando;

  Future<void> verificarSesion() async {
    final token = await _authService.obtenerToken();

    if (token != null) {
      _usuario = Usuario(
        nombre: 'Usuario Padlock',
        correo: 'usuario@padlock.com',
      );
    }

    _cargando = false;
    notifyListeners();
  }

  Future<bool> iniciarSesion(String usuario, String password) async {
    if (usuario == 'admin' && password == '123456') {
      await _authService.guardarToken('padlock_token_123');

      _usuario = Usuario(
        nombre: 'Administrador',
        correo: 'admin@padlock.com',
      );

      notifyListeners();
      return true;
    }

    return false;
  }

  Future<void> cerrarSesion() async {
    await _authService.eliminarToken();
    _usuario = null;
    notifyListeners();
  }
}