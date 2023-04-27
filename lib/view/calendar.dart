import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tfgproyecto/components/formatter.dart';
import 'package:tfgproyecto/model/Consumption.dart';
import 'package:tfgproyecto/view/GraficoConsumo.dart';
import 'package:intl/intl.dart';
import '../API/API.dart';
import '../API/db.dart';
import '../model/Supply.dart';
import '../provider/locale_provider.dart';

class CalendarPage extends StatefulWidget {
  final Supply supply;
  const CalendarPage({super.key, required this.supply});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  void _toggleRangeSelectionMode() {
    setState(() {
      _rangeSelectionMode = _rangeSelectionMode == RangeSelectionMode.toggledOff
          ? RangeSelectionMode.toggledOn
          : RangeSelectionMode.toggledOff;
      if (_rangeSelectionMode == RangeSelectionMode.toggledOff) {
        _rangeStart = null;
        _rangeEnd = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario'),
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: Provider.of<LocaleProvider>(context).locale.languageCode,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
            ),
            calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
                todayDecoration: BoxDecoration(
                    color: Colors.redAccent, shape: BoxShape.circle)),
            firstDay: DateTime.fromMillisecondsSinceEpoch(946684800000),
            lastDay: DateTime.now().add(const Duration(days: 300)),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              // Use `selectedDayPredicate` to determine which day is currently selected.
              // If this returns true, then `day` will be marked as selected.

              // Using `isSameDay` is recommended to disregard
              // the time-part of compared DateTime objects.
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                // Call `setState()` when updating the selected day
                setState(() {
                  if (_rangeSelectionMode == RangeSelectionMode.toggledOff) {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _rangeStart = null; // Important to clean those
                    _rangeEnd = null;
                  }
                });
                _rangeSelectionMode == RangeSelectionMode.toggledOn
                    ? print('$_rangeStart & $_rangeEnd')
                    : print(_selectedDay);
              }
            },
            onRangeSelected: (start, end, focusedDay) {
              debugPrint('Range selected: ${start} - ${end}');
              _rangeStart = start;
              _rangeEnd = end;
              setState(() {
                _selectedDay = null;
                _rangeStart = start;
                _rangeEnd = end;
              });
            },
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            rangeSelectionMode: _rangeSelectionMode,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _toggleRangeSelectionMode,
                child: Text(_rangeSelectionMode == RangeSelectionMode.toggledOn
                    ? 'Modo rango'
                    : 'Modo día'),
              ),
              ElevatedButton(
                child: const Text('Ver consumo'),
                onPressed: callbackFunction
              )
            ],
          ),
        ],
      ),
    );
  }

  void callbackFunction(){
    if(_selectedDay != null || _rangeEnd != null) {
      forward(context);
    }
  }

  void forward(BuildContext context) async {
    var database = await DB.openDB();
    List<Map<String, Object?>> list;
    String type;
    if (_rangeSelectionMode == RangeSelectionMode.toggledOn) {
      list = await database.query('consumptions',
          where: 'supplyId = ?1 AND date BETWEEN ?2 AND ?3',
          whereArgs: [
            widget.supply.cups,
            _rangeStart!.formatter(),
            _rangeEnd!.formatter()
          ]);
      type = "date";
    } else {
      list = await database.query('consumptions',
          where: 'supplyId = ?1 AND date BETWEEN ?2 AND ?3',
          whereArgs: [
            widget.supply.cups,
            _selectedDay!.formatter(),
            _selectedDay!.formatter()
          ]);
      type = "time";
    }

    List<Consumption> data = list.map((e) => Consumption.fromJson(e)).toList();

    //fetch from API
    if (data.isEmpty) {
      debugPrint("trayendo datos de API");
      if (_rangeSelectionMode == RangeSelectionMode.toggledOn) {
        data = await API.getConsumptionData(
            widget.supply.cups!,
            widget.supply.distributorCode!,
            _rangeStart!.formatterMonth(),
            _rangeEnd!.formatterMonth(),
            widget.supply.pointType!);
      } else {
        data = await API.getConsumptionData(
            widget.supply.cups!,
            widget.supply.distributorCode!,
            _selectedDay!.formatterMonth(),
            _selectedDay!.formatterMonth(),
            widget.supply.pointType!);
      }
      //insert into DB
      var batch = database.batch();
      for (var c in data) {
        batch.insert(
          "consumptions",
          {
            'date': c.date,
            'time': c.time,
            'consumptionKWh': c.consumptionKWh,
            'obtainMethod': c.obtainMethod,
            'supplyId': widget.supply.cups,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
      await batch.commit(noResult: true);
      debugPrint("Datos guardados en BD");
      //fetch from DB
      if (_rangeSelectionMode == RangeSelectionMode.toggledOn) {
        list = await database.query('consumptions',
            where: 'supplyId = ?1 AND date BETWEEN ?2 AND ?3',
            whereArgs: [
              widget.supply.cups,
              _rangeStart!.formatter(),
              _rangeEnd!.formatter()
            ]);
        type = "date";
      } else {
        list = await database.query('consumptions',
            where: 'supplyId = ?1 AND date BETWEEN ?2 AND ?3',
            whereArgs: [
              widget.supply.cups,
              _selectedDay!.formatter(),
              _selectedDay!.formatter()
            ]);
        type = "time";
      }

      data = list.map((e) => Consumption.fromJson(e)).toList();
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GraficoConsumo(data: data, type: type)),
    );
  }
}
