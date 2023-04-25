import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tfgproyecto/API/API.dart';
import 'package:tfgproyecto/API/encrypter.dart';
import 'package:tfgproyecto/view/mainPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../API/db.dart';
import '../model/User.dart';

class LoginScreen extends StatefulWidget {
 LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Duration get loginTime => Duration(milliseconds: 2000);
  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  Future<String?> _signInUser(LoginData data) async {
    Database database = await DB.openDB();
    var list = await database.rawQuery("SELECT * FROM users WHERE email = '${data.name}' AND password = '${encryptMyData(data.password)}';");

    if(list.isNotEmpty) {
      User user = User.fromArray(list.first);
      String token = await API.postLogin(user.nif, decryptMyData(user.datadisPassword));
      // Obtain shared preferences.
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("datadisToken", token);
      prefs.setString("email", user.email);
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
      String encryptPassword = encryptMyData(data.password!);
      String encryptDatadisPassword = encryptMyData(data.additionalSignupData!['datadisPassword']!);
      User user = User(email: data.name!, password: encryptPassword, name: data.additionalSignupData!['name']!, surname: data.additionalSignupData!['surname']!, nif: data.additionalSignupData!['nif']!, datadisPassword: encryptDatadisPassword);
      database.insert("users", user.toMap());
      // String token = await API.postLogin(data.additionalSignupData!['nif']!, data.additionalSignupData!['datadisPassword']!);
      // final prefs = await SharedPreferences.getInstance();
      // prefs.setString("datadisToken", token);
      // prefs.setString("email", user.email);
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
            passwordHint: AppLocalizations.of(context)!.passwordHint,
            confirmPasswordHint: AppLocalizations.of(context)!.confirmPasswordHint,
            loginButton: AppLocalizations.of(context)!.loginButton,
            signupButton: AppLocalizations.of(context)!.signupButton,
            forgotPasswordButton: AppLocalizations.of(context)!.forgotPasswordButton,
            goBackButton: AppLocalizations.of(context)!.goBackButton,
            recoverPasswordIntro: AppLocalizations.of(context)!.recoverPasswordIntro,
            recoverPasswordSuccess: AppLocalizations.of(context)!.recoverPasswordSuccess,
            recoverPasswordDescription: AppLocalizations.of(context)!.recoverPasswordDescription,
            providersTitleFirst: AppLocalizations.of(context)!.providersTitleFirst,
            recoverPasswordButton: AppLocalizations.of(context)!.recoverPasswordIntro,
            additionalSignUpSubmitButton: AppLocalizations.of(context)!.signupButton,
            additionalSignUpFormDescription: AppLocalizations.of(context)!.fill_survey,
            confirmPasswordError: AppLocalizations.of(context)!.password_not_match
        ),
        passwordValidator:  (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.empty_field;
          }
          return null;
        },
        additionalSignupFields: [
          UserFormField(
              keyName: 'name', displayName: AppLocalizations.of(context)!.name, userType: LoginUserType.name),
          UserFormField(
              keyName: 'surname', displayName: AppLocalizations.of(context)!.surname),
          const UserFormField(
              keyName: 'nif', icon: Icon(Icons.perm_identity), displayName: "NIF"),
          UserFormField(
              keyName: 'datadisPassword', displayName: AppLocalizations.of(context)!.datadis_password
          ),
        ],
        termsOfService: [
          TermOfService(id: "idTerm", mandatory: true,
              text: AppLocalizations.of(context)!.terms,
              linkUrl: "http://datadis.es",
              validationErrorMessage: AppLocalizations.of(context)!.empty_field
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
            builder: (context) => MainPage(),
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