import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tfgproyecto/components/app_bar.dart';
import 'package:tfgproyecto/model/User.dart';

import '../API/db.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    loadPrefs();
    super.initState();
  }

  Future<User> loadPrefs() async {
    final prefs2 = await SharedPreferences.getInstance();
    Database database = await DB.openDB();
    var list = await database.rawQuery(
        "SELECT * FROM users WHERE email = '${prefs2.getString("email")}';");
    User user = User.fromArray(list.first);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: loadPrefs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              User user = snapshot.data as User;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Datos del usuario'),
                  SizedBox(height: 20),
                  Text('Nombre: ${user.name} ${user.surname}'),
                  SizedBox(height: 10),
                  Text('Correo electrónico: ${user.email}'),
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () async {
                      var instance = await SharedPreferences.getInstance();
                      instance.remove("email");
                      Navigator.pushNamed(context, '/');
                    },
                    child: Text('Cerrar sesión'),
                  ),
                ],
              );
            }else{
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
