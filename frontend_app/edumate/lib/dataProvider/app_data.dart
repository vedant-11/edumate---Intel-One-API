import 'package:flutter/material.dart';

import '../model/faculty.dart';
import '../model/student.dart';

enum UserType { student, faculty }

class AppData extends ChangeNotifier {
  UserType? _userType;
  Faculty? _faculty;
  Student? _student;
  String? _deviceId;

  UserType get getUserType => _userType!;
  Faculty get getFacultyDetails => _faculty!;
  Student get getStudentDetails => _student!;
  String get getDeviceId => _deviceId!;

  set updateUserType(UserType type) {
    _userType = type;
    notifyListeners();
  }

  set updateFaculty(Faculty faculty) {
    _faculty = faculty;
    notifyListeners();
  }

  set updatestudent(Student student) {
    _student = student;
    notifyListeners();
  }

  set updateDeviceid(String id) {
    _deviceId = id;
    notifyListeners();
  }
}
