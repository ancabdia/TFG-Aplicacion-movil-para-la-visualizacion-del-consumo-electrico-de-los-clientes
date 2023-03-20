

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfgproyecto/view/login.dart';


class AppBars extends AppBar {
  AppBars({required Text title, context}):super(
    title: title,
    centerTitle: true,
    //elevation: 10.0,
    //automaticallyImplyLeading: false,
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.notifications),
        onPressed: () => print('notificaciones'),
      ),
      IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.clear();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ));
        },
      ),
    ],
  );
}
