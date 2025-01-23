import 'package:flutter/material.dart';

class SignupFormProvider extends ChangeNotifier {
  String _email = '';
  String _email1 = '';
  String _password = '';
  String _password1 = '';
  String _confirmPassword = '';
  String _name = '';
  String _gender = '';
  DateTime? _birthDate;
  double? _weight;
  double? _height;
  int? _bloodPressureSystolic;
  int? _bloodPressureDiastolic;
  int? _dailySteps;

  String get email => _email;
  String get email1 => _email1;
  String get password => _password;
  String get password1 => _password1;
  String get confirmPassword => _confirmPassword;
  String get name => _name;
  String get gender => _gender;
  DateTime? get birthDate => _birthDate;
  double? get weight => _weight;
  double? get height => _height;
  int? get bloodPressureSystolic => _bloodPressureSystolic;
  int? get bloodPressureDiastolic => _bloodPressureDiastolic;
  int? get dailySteps => _dailySteps;

  void updateEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    _password = value;
    notifyListeners();
  }

  void updateConfirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

    void updateEmail1(String value) {
    _email1 = value;
    notifyListeners();
  }

  void updatePassword1(String value) {
    _password1 = value;
    notifyListeners();
  }
  void updateName(String value) {
    _name = value;
    notifyListeners();
  }

  void updateGender(String value) {
    _gender = value;
    notifyListeners();
  }

  void updateBirthDate(DateTime value) {
    _birthDate = value;
    notifyListeners();
  }

  void updateWeight(double value) {
    _weight = value;
    notifyListeners();
  }

  void updateHeight(double value) {
    _height = value;
    notifyListeners();
  }

  void updateBloodPressureSystolic(int value) {
    _bloodPressureSystolic = value;
    notifyListeners();
  }

  void updateBloodPressureDiastolic(int value) {
    _bloodPressureDiastolic = value;
    notifyListeners();
  }

  void updateDailySteps(int value) {
    _dailySteps = value;
    notifyListeners();
  }
}
