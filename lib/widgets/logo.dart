import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String mensaje;

  const Logo({Key? key, required this.mensaje}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 50),
        width: 170,
        child: Column(
          children: [
            Image(image: AssetImage('assets/tag-logo.png')),
            SizedBox(
              height: 20,
            ),
            Text(
              this.mensaje,
              style: TextStyle(fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}
