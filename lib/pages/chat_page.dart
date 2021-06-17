import 'dart:io';

import 'package:chat/models/mensajes_respones.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _focusNode = FocusNode();
  List<ChatMessage> _messages = [];
  bool estaEscribiendo = false;

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    this
        .socketService
        .socket
        .on('mensaje-personal', (data) => _escucharMenasje(data));

    _cargarHistorial(this.chatService.usuarioPara.uid);
  }

  void _escucharMenasje(dynamic payload) {
    ChatMessage message = new ChatMessage(
        texto: payload['mensaje'],
        uid: payload['de'],
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 300)));
    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatService.usuarioPara;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(
                usuarioPara.nombre.substring(0, 2),
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              usuarioPara.nombre,
              style: TextStyle(color: Colors.black87, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
                reverse: true,
              ),
            ),
            Divider(
              height: 1,
            ),
            Container(
              height: 100,
              color: Colors.white,
              child: _inputChat(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _hundleSubmit,
              onChanged: (String texto) {
                setState(() {
                  if (texto.trim().length > 0) {
                    estaEscribiendo = true;
                  } else {
                    estaEscribiendo = false;
                  }
                });
              },
              decoration: InputDecoration.collapsed(hintText: 'Enviar mensaje'),
              focusNode: _focusNode,
            ),
          ),
          //Boton enviar
          Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: estaEscribiendo
                          ? () => _hundleSubmit(_textController.text)
                          : null,
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(Icons.send),
                          onPressed: estaEscribiendo
                              ? () => _hundleSubmit(_textController.text)
                              : null,
                        ),
                      ),
                    ))
        ],
      ),
    ));
  }

  _hundleSubmit(String texto) {
    if (texto.length == 0) return;
    print(texto);
    _textController.clear();

    _focusNode.requestFocus();
    final newMessage = ChatMessage(
      texto: texto,
      uid: authService.usuario.uid,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 400)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      estaEscribiendo = false;
    });

    this.socketService.socket.emit('mensaje-personal', {
      'de': this.authService.usuario.uid,
      'para': this.chatService.usuarioPara.uid,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // Off Socket

    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    // Cierro el canal de comunicacion, para evitar consumo de datos.
    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }

  void _cargarHistorial(String uid) async {
    List<Mensaje> chat = await this.chatService.getChat(uid);
    final history = chat.map((m) => new ChatMessage(
        texto: m.mensaje,
        uid: m.de,
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 0))
          ..forward()));

    setState(() {
      _messages.insertAll(0, history);
    });
  }
}
