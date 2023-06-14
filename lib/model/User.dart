import 'Supply.dart';

class User{
  String? email;
  String? password;
  String? name;
  String? surname;
  String? nif;
  String? datadisPassword;

  User.empty();

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