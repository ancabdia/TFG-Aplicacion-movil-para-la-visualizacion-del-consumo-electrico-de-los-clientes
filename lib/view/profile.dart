import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Datos del usuario'),
            SizedBox(height: 20),
            Text('Nombre: '),
            SizedBox(height: 10),
            Text('Correo electrónico: juanperez@example.com'),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // Implementar el código para cerrar sesión aquí
              },
              child: Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
