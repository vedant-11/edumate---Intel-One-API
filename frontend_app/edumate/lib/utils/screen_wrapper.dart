import 'package:edumate/common_screens/community.dart';
import 'package:edumate/dataProvider/app_data.dart';
import 'package:edumate/faculty_screens/Profile.dart';
import 'package:edumate/faculty_screens/dashboard.dart';
import 'package:edumate/student_screens/dashboard_stud.dart';
import 'package:edumate/student_screens/profile_stud.dart';
import 'package:edumate/student_screens/test_portal.dart';
import 'package:edumate/utils/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenWrapper extends StatefulWidget {
  const ScreenWrapper({Key? key}) : super(key: key);

  @override
  State<ScreenWrapper> createState() => _ScreenWrapperState();
}

class _ScreenWrapperState extends State<ScreenWrapper> {
  int _selectedTab = 0;
  void onTap(int x) {
    setState(() {
      _selectedTab = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserType userType =
        Provider.of<AppData>(context, listen: false).getUserType;
    var user = FirebaseAuth.instance.currentUser!;
    int atIndex = user.email!.indexOf("@");

    // Extract the part before the "@" symbol
    String path = user.email!.substring(0, atIndex);
    DatabaseReference newUserRef = FirebaseDatabase.instance.ref().child(
        '${userType == UserType.faculty ? 'Faculties' : 'Students'}/$path');
    print(userType);
    List<Widget> children = [
      userType == UserType.faculty ? Dashboard() : DashboardStud(),
      userType == UserType.faculty ? TestPortal() : TestPortal(),
      Navigator(
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (context) => Community());
        },
      ),
      userType == UserType.faculty ? Profile() : ProfileStud(),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF4F4F4),
        leading: CircleAvatar(
          radius: 27.5,
          backgroundImage: AssetImage('assets/profile_pic.png'),
        ),
        actions: [
          Container(
            height: 70,
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(150),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/token.gif',
                  height: 50,
                  width: 52,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  width: 5,
                ),
                StreamBuilder(
                    stream: newUserRef.onValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.data!.snapshot.value != null) {
                        Map<dynamic, dynamic> atts =
                            snapshot.data!.snapshot.value as dynamic;
                        return Text(atts['points'].toString());
                      }
                      return Container();
                    })
              ],
            ),
          )
        ],
      ),
      body: IndexedStack(
        children: children,
        index: _selectedTab,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.grey,
        selectedItemColor: AppColors.blackColor,
        currentIndex: _selectedTab,
        onTap: onTap,
        backgroundColor: Colors.white.withOpacity(0.79),
        items: [
          BottomNavigationBarItem(
            label: 'Dashboard',
            icon: ImageIcon(AssetImage('assets/dashboard.png')),
          ),
          BottomNavigationBarItem(
            label: 'Test',
            icon: ImageIcon(AssetImage('assets/test.png')),
          ),
          BottomNavigationBarItem(
            label: 'Community',
            icon: ImageIcon(AssetImage('assets/community.png')),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: ImageIcon(AssetImage('assets/profile.png')),
          )
        ],
      ),
    );
  }
}
