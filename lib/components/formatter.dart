import 'package:intl/intl.dart';

extension PypeDates on DateTime {
  DateTime addDays(int days) {
    return copyWith(day: day + days);
  }

  bool isDateEqual(date) {
    return year == date.year && month == date.month && day == date.day;
  }

  String toDateString() {
    return '$year-${month.toString().padLeft(2, "0")}-${day.toString().padLeft(2, "0")}';
  }

  DateTime stringToDate(String date) {
    List d = date.split('-');
    return DateTime(int.parse(d[0]), int.parse(d[1]), int.parse(d[2]));
  }

  DateTime startOfDay() {
    return copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
  }

  DateTime endOfDay() {
    return copyWith(
        hour: 23, minute: 59, second: 59, millisecond: 999, microsecond: 999);
  }

  String formatter(){
    return DateFormat('yyyy/MM/dd').format(this);
  }

  String formatterMonth(){
    return DateFormat('yyyy/MM').format(this);
  }

  pypeDate() {
    DateTime today = DateTime.now().startOfDay();
    if (startOfDay().isDateEqual(today)) {
      return "Hoy, ${DateFormat('dd.MM.yyyy').format(this)}";
    }
    if (startOfDay().isDateEqual(today.add(const Duration(days: 1)))) {
      return "Morgen, ${DateFormat('dd.MM.yyyy').format(this)}";
    }

    return '${DateFormat('E', "de").format(this)}, ${DateFormat('dd.MM.yyyy').format(this)}';
  }
}