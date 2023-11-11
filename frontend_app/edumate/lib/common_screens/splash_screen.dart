import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:edumate/common_screens/welcome.dart';
import 'package:edumate/dataProvider/app_data.dart';
import 'package:edumate/helpers/data_helper.dart';
import 'package:edumate/utils/app_color.dart';
import 'package:edumate/utils/screen_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Connectivity _connectivity = Connectivity();

  bool ActiveConnection = false;
  String T = "";
  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      DataHelper.showSnackbar('Check your internet connection', context);
      setState(() {
        ActiveConnection = false;
        T = "Turn On the data and repress again";
      });
    }
  }

  bool push = false;
  setUpVars() async {
    await checkUserConnection();
    if (FirebaseAuth.instance.currentUser != null) {
      User user = FirebaseAuth.instance.currentUser!;
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
        Provider.of<AppData>(context, listen: false).updateFaculty = fac;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ScreenWrapper()));
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
          Provider.of<AppData>(context, listen: false).updatestudent = st;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ScreenWrapper()));
        }
      }
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 0), () {
      setUpVars();
    });

    // if (FirebaseAuth.instance.currentUser != null) {
    //   setUpVars();
    // }
    // // Future.delayed(Duration(seconds: 3), () {});
    // if (FirebaseAuth.instance.currentUser == null) {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => LoginScreen()));
    // } else {
    //   while (push != true) {}
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => HomePage()));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 170),
              child: Image.asset(
                'assets/splash.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 77,
            ),
            Text(
              'Balance is key',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'study diligently, rest fully, and cherish your mental health.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackColor),
              ),
            ),
            SizedBox(
              height: 64,
            ),
            Text(
              'Powered By',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blackColor),
            ),
            Container(
              height: 120,
              width: 120,
              alignment: Alignment.center,
              child: Image.asset(
                'assets/one_api.png',
                fit: BoxFit.cover,
              ),
            )
          ],
        ));
  }
}
