import 'Supply.dart';

class User{
  final String email;
  final String password;
  final String name;
  final String surname;
  final String nif;
  final String datadisPassword;

  User({
    required this.email,
    required this.password,
    required this.name,
    required this.surname,
    required this.nif,
    required this.datadisPassword,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'surname': surname,
      'nif': nif,
      'datadisPassword' : datadisPassword
    };
  }

  factory User.fromArray(Map<String, Object?> map) => User(
    email: map['email'] as String,
    password: map['password'] as String,
    name: map['name'] as String,
    surname: map['surname'] as String,
    nif: map['nif'] as String,
    datadisPassword: map['datadisPassword'] as String,
  );
}