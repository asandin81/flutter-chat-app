import 'package:chat/models/usuario.dart';
import 'package:chat/global/environment.dart';
import 'package:chat/models/usuarios_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final token = await AuthService.getToken();
      if (token != null) {
        final url = Uri.parse('${Environment.apiUrl}/usuarios');
        final resp = await http.get(url,
            headers: {'Content-Type': 'application/json', 'x-token': token});
        final usuariosResponse = usuariosResponseFromJson(resp.body);
        return usuariosResponse.usuarios;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
