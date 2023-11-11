import 'package:edumate/helpers/cloud_helper.dart';
import 'package:edumate/helpers/request_helper.dart';
import 'package:edumate/model/question.dart';
import 'package:flutter/material.dart';

import '../model/faculty.dart';
import '../model/student.dart';

class DataHelper {
  String _baseUrl = "https://edumate-production-cdd9.up.railway.app";
  Future<Student> createStudent(Student student) async {
    var deviceId = await CloudHelper.getDeviceUdid();
    var data = {
      "_id": student.id,
      "name": student.name,
      "reg": student.reg,
      "email": student.email,
      "phone": int.parse(student.phone),
      "semester": student.semester,
      "section": student.section,
      "device": deviceId
    };
    var res = await RequestHelper.postRequest('$_baseUrl/student/', data)
        as Map<String, dynamic>;

    Student student1 = Student.fromMap(res['studentDetails']);

    return student1;
  }

  Future<Student> getstudentDetails(String registerNumber) async {
    var res =
        await RequestHelper.getRequest('$_baseUrl/student/$registerNumber');
    Student student1 = Student.fromMap(res[0]);
    return student1;
  }

  Future<Faculty> createFaculty(Faculty faculty) async {
    var data = {
      "_id": faculty.id,
      "facultyName": faculty.facultyName,
      "subjectName": faculty.subjectName,
      "section": faculty.section,
      "fn": faculty.fn,
      "email": faculty.email
    };
    var res = await RequestHelper.postRequest('$_baseUrl/faculty/', data)
        as Map<String, dynamic>;
    Faculty faculty1 = Faculty.fromMap(res['facultyDetails']);
    return faculty1;
  }

  Future<Faculty> getFacultyDetails(String registerNumber) async {
    var res =
        await RequestHelper.getRequest('$_baseUrl/faculty/$registerNumber');
    Faculty faculty1 = Faculty.fromMap(res['facultyDetails'][0]);
    return faculty1;
  }

  Future<bool> verifyDeviceId(String regNo, String id) async {
    var res = await RequestHelper.getRequest('$_baseUrl/student/$regNo/$id/');
    if (res == 'Verified') {
      return true;
    }
    return false;
  }

  Future<List<Question>> generateTest(String topicName) async {
    var data = {"topic": topicName};
    var res = await RequestHelper.postRequest('$_baseUrl/question', data);
    List<Question> ques = [];
    for (var d in res as List) {
      Question question = Question.fromMap(d);
      ques.add(question);
    }

    return ques;
  }

  Future<bool> getSentiment(String ques) async {
    var data = {"text": ques};
    var res = await RequestHelper.postRequest('$_baseUrl/sentiment', data);
    if (res['response'] == 'Yes') {
      return true;
    } else {
      return false;
    }
  }

  static showSnackbar(String title, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
