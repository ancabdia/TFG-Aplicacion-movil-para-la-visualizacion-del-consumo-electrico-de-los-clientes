

import 'package:flutter/material.dart';


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
        onPressed: () => {},
      ),
    ],
  );
}
