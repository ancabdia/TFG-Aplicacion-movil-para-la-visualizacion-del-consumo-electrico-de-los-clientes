import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

import 'package:tfgproyecto/main.dart';

import '../API/db.dart';
import '../model/User.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Duration get loginTime => const Duration(milliseconds: 2000);

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  Future<String?> _signInUser(LoginData data) async {
    
  }

  Future<String?> _signupUser(SignupData data) async{
   User user = User.complete(data.name!, data.password!, data.additionalSignupData!['name'], data.additionalSignupData!['surname'], data.additionalSignupData!['nif'], data.additionalSignupData!['datadisPassword']);

   DB.insert(user);
  }

  Future<String?> _recoverPassword(String name) async{

  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
        hideForgotPasswordButton: false,
        title: "Enotify",
        logo: AssetImage('assets/logo.png'),
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
              keyName: 'pass', displayName: "Contraseña DataDis"
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
            builder: (context) => const MyHomePage(title: 'pruba2'),
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



























