import 'package:edumate/dataProvider/app_data.dart';
import 'package:edumate/helpers/data_helper.dart';
import 'package:edumate/model/faculty.dart';
import 'package:edumate/model/student.dart';
import 'package:edumate/utils/app_color.dart';
import 'package:edumate/utils/screen_wrapper.dart';
import 'package:edumate/widgets/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool? _success;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var fullNameController = TextEditingController();
  var semester = TextEditingController();
  var section = TextEditingController();
  var registerNum = TextEditingController();
  var subject = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey1 = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void showSnackbar(String title) {
    final snackBar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  registerFaculty() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: 'Registering you... ',
            ));
    final User? user = (await _auth
            .createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
            .catchError((ex) {
      Navigator.pop(context);
      var thisex = ex;
      showSnackbar(thisex.message!);
    }))
        .user;

    print(user);
    if (user != null) {
      // Extract the part before the "@" symbol
      int atIndex = user.email!.indexOf("@");

      // Extract the part before the "@" symbol
      String path = user.email!.substring(0, atIndex);
      DatabaseReference newUserRef =
          FirebaseDatabase.instance.ref().child('Faculties/$path');
      Map userMap = {'registerNo': registerNum.text, 'points': 2000};
      Faculty faculty = Faculty(
          id: user.uid,
          facultyName: fullNameController.text,
          fn: registerNum.text,
          email: emailController.text,
          subjectName: subject.text,
          section: section.text);
      DataHelper dataHelper = DataHelper();
      var faculty1 = await dataHelper.createFaculty(faculty);
      Provider.of<AppData>(context, listen: false).updateUserType =
          UserType.faculty;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userType', UserType.faculty.index);
      Provider.of<AppData>(context, listen: false).updateFaculty = faculty1;

      await newUserRef.set(userMap);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ScreenWrapper()),
          (route) => false);
      setState(() {
        _success = true;
        print('registeration sucessfull');
      });
    } else {
      _success = false;
    }
  }

  registerStudent() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: 'Registering you... ',
            ));
    final User? user = (await _auth
            .createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
            .catchError((ex) {
      Navigator.pop(context);
      var thisex = ex;
      showSnackbar(thisex.message!);
    }))
        .user;

    print(user);
    if (user != null) {
      // Extract the part before the "@" symbol
      int atIndex = user.email!.indexOf("@");

      // Extract the part before the "@" symbol
      String path = user.email!.substring(0, atIndex);
      DatabaseReference newUserRef =
          FirebaseDatabase.instance.ref().child('Students/$path');
      Map userMap = {'registerNo': registerNum.text, 'points': 400};

      Student student = Student(
          id: user.uid,
          semester: int.parse(semester.text),
          reg: registerNum.text,
          name: fullNameController.text,
          email: emailController.text,
          section: section.text,
          phone: phoneController.text,
          points: 0);
      DataHelper dataHelper = DataHelper();
      var student1 = await dataHelper.createStudent(student);
      Provider.of<AppData>(context, listen: false).updateUserType =
          UserType.student;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userType', UserType.student.index);
      Provider.of<AppData>(context, listen: false).updatestudent = student1;
      await newUserRef.set(userMap);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ScreenWrapper()),
          (route) => false);
      setState(() {
        _success = true;
        print('registeration sucessfull');
      });
    } else {
      _success = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: SafeArea(
            key: scaffoldKey1,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 35, right: 35, top: 93),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Create Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 30,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 23,
                        ),
                        Text(
                          'Create an account so you can explore all the existing jobs',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
                        ),
                        SizedBox(
                          height: 74,
                        ),
                        TabBar(tabs: [
                          Tab(
                            text: 'Student',
                          ),
                          Tab(
                            text: 'Faculty',
                          ),
                        ]),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          height: 800,
                          child: TabBarView(children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Column(
                                children: [
                                  TextField(
                                    cursorColor: AppColors.primaryColor,
                                    controller: fullNameController,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      labelText: 'Name',
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.blackColor),
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 10.0),
                                    ),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  TextField(
                                    cursorColor: AppColors.primaryColor,
                                    controller: registerNum,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      labelText: 'Register Number',
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.blackColor),
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 10.0),
                                    ),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  TextField(
                                    cursorColor: AppColors.primaryColor,
                                    controller: phoneController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      labelText: 'Phone Number',
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.blackColor),
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 10.0),
                                    ),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  TextField(
                                    cursorColor: AppColors.primaryColor,
                                    controller: semester,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      labelText: 'Semester',
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.blackColor),
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 10.0),
                                    ),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  TextField(
                                    cursorColor: AppColors.primaryColor,
                                    controller: section,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      labelText: 'Section',
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.blackColor),
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 10.0),
                                    ),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  TextField(
                                    cursorColor: AppColors.primaryColor,
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      labelText: 'Email address',
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.blackColor),
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 10.0),
                                    ),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  TextField(
                                    cursorColor: AppColors.primaryColor,
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      labelText: 'Password',
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.blackColor),
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 10.0),
                                    ),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  MaterialButton(
                                    minWidth: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    onPressed: () async {
                                      await registerStudent();
                                    },
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                    color: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Already have an account',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Column(
                                children: [
                                  TextField(
                                    cursorColor: AppColors.primaryColor,
                                    controller: fullNameController,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      labelText: 'Name',
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.blackColor),
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 10.0),
                                    ),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  TextField(
                                    cursorColor: AppColors.primaryColor,
                                    controller: registerNum,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      labelText: 'Register Number',
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.blackColor),
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 10.0),
                                    ),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  TextField(
                                    cursorColor: AppColors.primaryColor,
                                    controller: subject,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      labelText: 'Subject',
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.blackColor),
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 10.0),
                                    ),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  TextField(
                                    cursorColor: AppColors.primaryColor,
                                    controller: section,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      labelText: 'Section',
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.blackColor),
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 10.0),
                                    ),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  TextField(
                                    cursorColor: AppColors.primaryColor,
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      labelText: 'Email address',
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.blackColor),
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 10.0),
                                    ),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  TextField(
                                    cursorColor: AppColors.primaryColor,
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor)),
                                      labelText: 'Password',
                                      labelStyle: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.blackColor),
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 10.0),
                                    ),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  MaterialButton(
                                    minWidth: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    onPressed: () async {
                                      await registerFaculty();
                                    },
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                    color: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Already have an account',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ))
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
