import 'Supply.dart';

class User{
  String email;
  String password;
  String? name;
  String? surname;
  String? nif;
  String? datadisPassword;

  User.single(this.email, this.password);

  User.complete(this.email, this.password, this.name, this.surname, this.nif,
      this.datadisPassword);

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
}