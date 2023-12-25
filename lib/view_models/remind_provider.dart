import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemindProvider extends ChangeNotifier {
  DateTime _timeAlarm = DateTime.now();
  bool _isRemind = false;

  setRemind(value) async {
    _isRemind = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_remind', value);
    notifyListeners();
  }
  setTimeAlarm(value) async {
    _timeAlarm = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('remind_reading', value.toString());
    notifyListeners();
  }
  bool get isRemind => _isRemind;
  DateTime get timeAlarm => _timeAlarm;

  checkRemind() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final remind =  prefs.getBool('is_remind') ?? false;
    setRemind(remind);
    final date = prefs.getString('remind_reading') ?? DateTime.now().toString();
    setTimeAlarm(DateTime.parse(date));
    
  }
}