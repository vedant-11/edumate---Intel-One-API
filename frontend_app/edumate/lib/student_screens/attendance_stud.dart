import 'package:edumate/dataProvider/app_data.dart';
import 'package:edumate/helpers/cloud_helper.dart';
import 'package:edumate/helpers/data_helper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:provider/provider.dart';

import '../utils/app_color.dart';

class AttendanceStud extends StatefulWidget {
  final String subjectName;
  final String facultyName;
  const AttendanceStud(
      {Key? key, required this.subjectName, required this.facultyName})
      : super(key: key);

  @override
  State<AttendanceStud> createState() => _AttendanceStudState();
}

class _AttendanceStudState extends State<AttendanceStud> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 38,
            ),
            StreamBuilder(
                stream: FirebaseDatabase.instance
                    .ref()
                    .child('${widget.subjectName}/${widget.facultyName}/status')
                    .onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data!.snapshot.value != null) {
                    Map<dynamic, dynamic> atts =
                        snapshot.data!.snapshot.value as dynamic;
                    if (atts['status'] == 'started') {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          onPressed: () async {
                            var pos = await CloudHelper.determinePosition();
                            DataHelper dataHelper = DataHelper();
                            var student =
                                Provider.of<AppData>(context, listen: false)
                                    .getStudentDetails;
                            var id = await CloudHelper.getDeviceUdid();
                            var deviceStatus = await dataHelper.verifyDeviceId(
                                student.reg, id);
                            var polygon =
                                await CloudHelper.getPolygonFromFirebase(
                                    widget.subjectName, widget.facultyName);
                            var locationStatus =
                                CloudHelper.checkPointInPolygon(
                                    LatLng(pos.latitude, pos.longitude),
                                    polygon);
                            if (deviceStatus == true &&
                                locationStatus == false) {
                              await CloudHelper.markAttendance(student,
                                  widget.subjectName, widget.facultyName);
                            }
                          },
                          child: Text(
                            'Give Attendance',
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
                      );
                    }
                    return Text("Attendance hasn't started yet");
                  }
                  return Container();
                })
          ],
        ),
      ),
    );
  }
}
