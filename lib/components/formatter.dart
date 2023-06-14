import 'package:intl/intl.dart';

extension DurationExtend on Duration{
  /// Converts the duration into a readable string
  /// 05:15
  String toHoursMinutes() {
    String twoDigitMinutes = _toTwoDigits(this.inMinutes.remainder(60));
    return "${_toTwoDigits(this.inHours)}:$twoDigitMinutes";
  }

  /// Converts the duration into a readable string
  /// 05:15:35
  String toHoursMinutesSeconds() {
    String twoDigitMinutes = _toTwoDigits(this.inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(this.inSeconds.remainder(60));
    return "${_toTwoDigits(this.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String _toTwoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}

extension PypeDates on DateTime {
  

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

  String toTwoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
  

  String formatter(){
    return DateFormat('yyyy/MM/dd').format(this);
  }

  String formatter2(){
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String formatterMonth(){
    return DateFormat('yyyy/MM').format(this);
  }

  
}