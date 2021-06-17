import 'package:chat/global/environment.dart';
import 'package:chat/models/mensajes_respones.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioId) async {
    try {
      final token = await AuthService.getToken();
      if (token != null) {
        final url = Uri.parse('${Environment.apiUrl}/mensajes/$usuarioId');
        final resp = await http.get(url,
            headers: {'Content-Type': 'application/json', 'x-token': token});
        final mensajesResponse = mensajesResponseFromJson(resp.body);
        return mensajesResponse.mensajes;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
