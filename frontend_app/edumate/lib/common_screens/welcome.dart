import 'package:edumate/common_screens/auth/login_screen.dart';
import 'package:edumate/common_screens/auth/register_screen.dart';
import 'package:flutter/material.dart';

import '../utils/app_color.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
                child: Image.asset(
                  'assets/welcome.png',
                  fit: BoxFit.cover,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Dive into the world of learning',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 35,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 23,
                  ),
                  Text(
                    'Explore the community to enhance the learning experience',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blackColor,
                    ),
                  ),
                  SizedBox(
                    height: 36,
                  ),
                  MaterialButton(
                    minWidth: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      'Login',
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
                    height: 20,
                  ),
                  MaterialButton(
                    minWidth: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()));
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    color: AppColors.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
