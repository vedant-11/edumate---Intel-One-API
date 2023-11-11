// ignore_for_file: prefer_const_constructors

import 'package:edumate/common_screens/auth/register_screen.dart';
import 'package:edumate/helpers/data_helper.dart';
import 'package:edumate/utils/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dataProvider/app_data.dart';
import '../../utils/screen_wrapper.dart';
import '../../widgets/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  login() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: 'Logging you in... ',
            ));
    try {
      final user = (await _auth
              .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
              .catchError((ex) {
        Navigator.pop(context);
        var thisex = ex;
        showSnackbar(thisex.message!);
      }))
          .user;
      if (user != null) {
        bool gotData = false;
        int atIndex = user.email!.indexOf("@");

        // Extract the part before the "@" symbol
        String path = user.email!.substring(0, atIndex);
        DatabaseReference facultyPath =
            FirebaseDatabase.instance.ref().child('Faculties/$path');
        DatabaseReference studentPath =
            FirebaseDatabase.instance.ref().child('Students/$path');

        var e = await facultyPath.once();
        if (e.snapshot.exists) {
          Provider.of<AppData>(context, listen: false).updateUserType =
              UserType.faculty;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('userType', UserType.faculty.index);
          Map<dynamic, dynamic> data = e.snapshot.value as dynamic;
          var regNo = data['registerNo'] as String;
          DataHelper dataHelper = DataHelper();
          gotData = true;
          var fac = await dataHelper.getFacultyDetails(regNo);
          Navigator.pop(context);
          Provider.of<AppData>(context, listen: false).updateFaculty = fac;
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScreenWrapper()),
          );
          print('done');
        }
        if (gotData == false) {
          var d = await studentPath.once();
          if (d.snapshot.exists) {
            Provider.of<AppData>(context, listen: false).updateUserType =
                UserType.student;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setInt('userType', UserType.faculty.index);
            Map<dynamic, dynamic> data = d.snapshot.value as dynamic;
            var regNo = data['registerNo'] as String;
            DataHelper dataHelper = DataHelper();
            var st = await dataHelper.getstudentDetails(regNo);
            Navigator.pop(context);
            Provider.of<AppData>(context, listen: false).updatestudent = st;
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScreenWrapper()),
            );
          }
        }
      }
      Navigator.pop(context);
      showSnackbar('${user!.email} signed in');
    } catch (e) {
      showSnackbar(e.toString());
      print(e.toString());
    }
  }

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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, top: 93),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Login',
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
                    'Welcome back you’ve been missed!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ),
                  SizedBox(
                    height: 74,
                  ),
                  TextField(
                    cursorColor: AppColors.primaryColor,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: AppColors.primaryColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: AppColors.primaryColor)),
                      labelText: 'Email address',
                      labelStyle:
                          TextStyle(fontSize: 14, color: AppColors.blackColor),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  TextField(
                    cursorColor: AppColors.primaryColor,
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: AppColors.primaryColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: AppColors.primaryColor)),
                      labelText: 'Password',
                      labelStyle:
                          TextStyle(fontSize: 14, color: AppColors.blackColor),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Forgot your password?',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    minWidth: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    onPressed: () async {
                      await login();
                    },
                    child: Text(
                      'Sign In',
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
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()));
                      },
                      child: Text(
                        'Create new account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ))
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
