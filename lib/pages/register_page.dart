import 'package:chat/widgets/boton_azul.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        // lo baja un poco por si el movil tiene algo como camaras
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(), // Al hacer scroll rebota
          child: Container(
            height: MediaQuery.of(context).size.height *
                0.9, // Se hace que ocupe el 90% de la pagina
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(
                  mensaje: 'Registro',
                ),
                _Form(),
                Labels(
                  ruta: 'login',
                  texto: 'Ingresar en tu cuenta!',
                  subtitulo: 'Ya tienes cuenta?',
                ),
                Text(
                  'Terminos y condiciones de uso',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                      fontWeight: FontWeight.w300),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.lock,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            isPassword: true,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock,
            placeholder: 'Password',
            isPassword: true,
            textController: passCtrl,
          ),
          BotonAzul(
            texto: 'Registrar',
            onPressed: () {
              print(passCtrl.text);
            },
          ),
        ],
      ),
    );
  }
}