import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

encryptInit() async {
  await dotenv.load(fileName: '/Users/Andres/IdeaProjects/TFGProyecto/configPassword.env');
}
// Accede a la clave y al vector de inicialización como variables de entorno
final key = Key.fromUtf8(dotenv.get('MY_ENCRYPTION_KEY'));
final iv = IV.fromUtf8(dotenv.get('MY_ENCRYPTION_IV'));

//encrypt
String encryptMyData(String password) {
  final e = Encrypter(AES(key, mode: AESMode.cbc));
  final encryptedData = e.encrypt(password, iv: iv);
  return encryptedData.base64;
}

//dycrypt
String decryptMyData(String encryptPassword) {
  final e = Encrypter(AES(key, mode: AESMode.cbc));
  final decryptedData = e.decrypt(Encrypted.fromBase64(encryptPassword), iv: iv);
  return decryptedData;
}
