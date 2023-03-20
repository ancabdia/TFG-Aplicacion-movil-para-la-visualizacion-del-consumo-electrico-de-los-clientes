import 'dart:developer';

import 'package:encrypto_flutter/encrypto_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tfgproyecto/API/API.dart';
import 'package:tfgproyecto/view/home_screen.dart';
import 'package:tfgproyecto/view/mainPage.dart';
import 'dart:convert';

import 'package:tfgproyecto/view/profile.dart';

import '../API/db.dart';
import '../model/User.dart';
import 'GraficoConsumo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Duration get loginTime => const Duration(milliseconds: 2000);
  late Encrypto encrypto;
  late var publicKey;

  @override
  void initState(){
    encrypto = Encrypto(Encrypto.RSA, bitLength: 128);
    publicKey = encrypto.sterilizePublicKey();
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  Future<String?> _signInUser(LoginData data) async {
    Database database = await DB.openDB();
    var list = await database.rawQuery("SELECT * FROM users WHERE email = '${data.name}' AND password = '${data.password}';");

    if(list.isNotEmpty) {
      User user = User.fromArray(list.first);
      String token = await API.postLogin(user.nif, user.datadisPassword);
      // Obtain shared preferences.
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("datadisToken", token);
    } else{
      return Future.delayed(loginTime).then((_) {
        return 'Error code: usuario no es correcto';
      });
    }
  }

  Future<String?> _signupUser(SignupData data) async{
    Database database = await DB.openDB();
    var tempUser = await database.rawQuery("SELECT * FROM users WHERE email = '${data.name}' AND password = '${data.password}' OR nif = '${data.additionalSignupData!['nif']}';");

    if(tempUser.isEmpty){
      User user = User(email: data.name!, password: data.password!, name: data.additionalSignupData!['name']!, surname: data.additionalSignupData!['surname']!, nif: data.additionalSignupData!['nif']!, datadisPassword: data.additionalSignupData!['datadisPassword']!);
      database.insert("users", user.toMap());
      String token = await API.postLogin(data.additionalSignupData!['nif']!, data.additionalSignupData!['datadisPassword']!);
      print(token);
    }else{
      return Future.delayed(loginTime).then((_) {
        return 'Error code: DNI ${data.additionalSignupData!["nif"]!} ya registrado en el sistema';
      });
    }
  }

  Future<String?> _recoverPassword(String name) async{

  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
        hideForgotPasswordButton: false,
        title: "Enotify",
        logo: const AssetImage('assets/logo.png'),
        userType: LoginUserType.email,
        theme: LoginTheme(

        ),
        messages: LoginMessages(
            userHint: "email",
            passwordHint: "Contraseña",
            confirmPasswordHint: "Confirmar contraseña",
            loginButton: "Iniciar sesión",
            signupButton: "Registro",
            forgotPasswordButton: "¿Has olvidado tu contraseña?",
            goBackButton: "Cancelar",
            recoverPasswordIntro: "Recuperar contaseña",
            recoverPasswordSuccess: "Se ha enviado a tu dirección de email el cambio de contraseña.",
            recoverPasswordDescription: "Recibira en su correo las instrucciones para realizar el cambio de contraseña.",
            providersTitleFirst: "O inicia sesion a través de ...",
            recoverPasswordButton: "Recuperar contraseña",
            additionalSignUpSubmitButton: "Registrarse"
        ),
        passwordValidator:  (value) {
          if (value == null || value.isEmpty) {
            return 'Debe ingresar una contraseña';
          }
          return null;
        },
        additionalSignupFields: const [
          UserFormField(
              keyName: 'name', displayName: "Nombre", userType: LoginUserType.name),
          UserFormField(
              keyName: 'surname', displayName: "Apellido"),
          UserFormField(
              keyName: 'nif', icon: Icon(Icons.perm_identity), displayName: "NIF"),
          UserFormField(
              keyName: 'datadisPassword', displayName: "Contraseña DataDis"
          ),

          // UserFormField(
          //   keyName: 'phone',
          //   displayName: 'Numero de telefono',
          //   userType: LoginUserType.phone,
          // ),
        ],
        termsOfService: [
          TermOfService(id: "idTerm", mandatory: true,
              text: "Acepta terminos y condiciones",
              linkUrl: "http://datadis.es",
              validationErrorMessage: "Debe aceptar los terminos"
          )
        ],
        loginProviders: <LoginProvider>[
          LoginProvider(
            icon: Icons.map,
            label: 'Google',
            callback: () async {

            },
          ),
          LoginProvider(
            icon: Icons.face,
            label: 'Facebook',
            callback: () async {
              debugPrint('start facebook sign in');
              await Future.delayed(loginTime);
              debugPrint('stop facebook sign in');
              return null;
            },
          ),
        ],
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const MainPage(),
          ));
        },
        onLogin: _signInUser,
        onSignup: _signupUser,
        onRecoverPassword: _recoverPassword,
        onConfirmSignup: null,
        savedEmail: 'andres97carmen@hotmail.es',
        savedPassword: '',
      );
  }
}