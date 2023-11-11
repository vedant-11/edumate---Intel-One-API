import 'package:edumate/helpers/cloud_helper.dart';
import 'package:edumate/utils/app_color.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:maps_toolkit/maps_toolkit.dart';

class Attendance extends StatefulWidget {
  final String subjectName;
  final String facultyName;
  const Attendance(
      {Key? key, required this.subjectName, required this.facultyName})
      : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  bool attendanceStarted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              SizedBox(
                height: 38,
              ),
              MaterialButton(
                minWidth: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                onPressed: () async {
                  var pos = await CloudHelper.determinePosition();
                  List<LatLng> cood = CloudHelper.getSquareCoordinates(
                      refrencePoint: LatLng(pos.latitude, pos.longitude));
                  await CloudHelper.updatePolyOnDb(
                      cood, widget.subjectName, widget.facultyName);

                  setState(() {
                    attendanceStarted = !attendanceStarted;
                  });
                },
                child: Text(
                  attendanceStarted ? 'Stop Attendance' : 'Take Attendance',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                color: attendanceStarted
                    ? AppColors.secondaryColor
                    : Color(0xFF94A5FE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .ref()
                      .child(
                          '${widget.subjectName}/${widget.facultyName}/attendance')
                      .onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data!.snapshot.value != null) {
                      Map<dynamic, dynamic> atts =
                          snapshot.data!.snapshot.value as dynamic;
                      return ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemBuilder: (context, index) {
                          var entry = atts.entries.elementAt(index);
                          Map<String, dynamic> data =
                              Map<String, dynamic>.from(entry.value);
                          DateTime d = DateTime.parse(data['time']);
                          return ListTile(
                            title: Text(data['name']),
                            subtitle: Text(data['regNo']),
                            trailing: Text('${d.hour}:${d.minute}'),
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 27.5,
                            ),
                          );
                        },
                        itemCount: atts.length,
                      );
                    } else {
                      return Image.asset('assets/loading.gif');
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
