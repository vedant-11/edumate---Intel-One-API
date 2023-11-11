import 'dart:ui';

import 'package:edumate/common_screens/auth/login_screen.dart';
import 'package:edumate/dataProvider/app_data.dart';
import 'package:edumate/model/student.dart';
import 'package:edumate/utils/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileStud extends StatefulWidget {
  const ProfileStud({Key? key}) : super(key: key);

  @override
  State<ProfileStud> createState() => _ProfileStudState();
}

class _ProfileStudState extends State<ProfileStud> {
  Widget build(BuildContext context) {
    var provider = Provider.of<AppData>(context);
    Student student = provider.getStudentDetails;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false);
              },
              icon: Icon(Icons.logout))
        ],
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: CircleAvatar(
              radius: 95,
              backgroundColor: AppColors.secondaryColor,
              child: CircleAvatar(
                radius: 85,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: NetworkImage(
                      'https://cdn.pixabay.com/photo/2018/01/15/07/52/woman-3083390_1280.jpg'),
                ),
              ),
            ),
          ),
          Text(
            student.name,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(height: 5),
          Text(
            "Student",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          SizedBox(height: 15),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  blurRadius: 24,
                  spreadRadius: 16,
                  color: Colors.black.withOpacity(0.2),
                )
              ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 40.0,
                    sigmaY: 40.0,
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ProfRow(
                            ques: 'Registeration No.',
                            answer: student.reg,
                          ),
                          ProfRow(
                            ques: 'Email',
                            answer: student.email,
                          ),
                          ProfRow(
                            ques: 'Semester',
                            answer: student.semester.toString(),
                          ),
                          ProfRow(
                            ques: 'Section',
                            answer: student.section,
                          ),
                          ProfRow(
                            ques: 'Phone',
                            answer: student.phone,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfRow extends StatelessWidget {
  final String ques;
  final String answer;
  const ProfRow({
    super.key,
    required this.ques,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$ques: ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        Text(
          answer,
          style:
              TextStyle(color: Color(0xFFD8D8D8), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
