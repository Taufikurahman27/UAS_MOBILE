import 'package:flutter/material.dart';

class UserData extends ChangeNotifier {
  String _name = '';
  String _gender = '';
  String _work = '';
  String _dob = '';
  double _height = 0;
  double _weight = 0;

  String get name => _name;
  String get gender => _gender;
  String get work => _work;
  String get dob => _dob;
  double get height => _height;
  double get weight => _weight;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setGender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  void setWork(String work) {
    _work = work;
    notifyListeners();
  }

  void setDob(String dob) {
    _dob = dob;
    notifyListeners();
  }

  void setHeight(double height) {
    _height = height;
    notifyListeners();
  }

  void setWeight(double weight) {
    _weight = weight;
    notifyListeners();
  }
}
