

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfgproyecto/model/Language.dart';
import 'package:tfgproyecto/provider/locale_provider.dart';
import 'package:tfgproyecto/view/login.dart';



import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';


class AppBars extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  AppBars({required this.title});

  @override
  _AppBarsState createState() => _AppBarsState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppBarsState extends State<AppBars> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      centerTitle: true,
      actions: <Widget>[
      DropdownButton(
        // value: Provider.of<LocaleProvider>(context, listen: false).locale,
        icon: const Icon(Icons.language, color: Colors.white,),
        items: Language.languageList().map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(value: lang,child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(lang.flag, style: TextStyle(fontSize: 30),),
            Text(lang.name)
          ],
        ))).toList(),
        underline: const SizedBox(),
        onChanged: (lang) {
          final provider = Provider.of<LocaleProvider>(context, listen: false);  
          provider.setLocale(Locale((lang as Language).languageCode));
          
          setState(() {
            
          });
        },
        ),
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
            builder: (context) => LoginScreen(),
          ));
        },
      ),
    ],
    );
  }
}
