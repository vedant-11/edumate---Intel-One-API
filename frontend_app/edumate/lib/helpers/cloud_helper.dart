import 'dart:io';
import 'dart:math' as math;

import 'package:edumate/model/resource.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_toolkit/maps_toolkit.dart';

import '../model/student.dart';

class CloudHelper {
  static final storageRef = FirebaseStorage.instance.ref();
  static final dbRef = FirebaseDatabase.instance.ref();

  static uploadToFirebase(File file, String path) async {
    try {
      final mountainsRef = storageRef.child('$path/');
      var link = await mountainsRef.putFile(file);
      return link;
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  static Future<String?> getDownloadLink(String path) async {
    try {
      final mountainsRef = storageRef.child(path);
      var link = await mountainsRef.getDownloadURL();
      return link;
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  static deleteFile(String path) async {
    try {
      final mountainsRef = storageRef.child(path);
      await mountainsRef.delete();
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  static Future<List<Reference>?> listAllFiles(String path) async {
    try {
      final mountainsRef = storageRef.child(path);
      ListResult list = await mountainsRef.listAll();
      return list.items;
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  static uploadResourcestoDb(Resource resource) async {
    var subRef = dbRef.child('resources/${resource.domain}');
    await subRef.set(resource.toMap());
  }

  static Future<FilePickerResult?> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    // File file = File(result!.files.single.path!);
    // var link = await uploadToFirebase(file, domain);

    if (result != null) {
      return result;
    } else {
      // User canceled the picker
    }
  }

  static List<LatLng> getSquareCoordinates(
      {required LatLng refrencePoint, double size = 40}) {
    double referenceLatitude =
        refrencePoint.latitude; // Latitude of the reference point
    double referenceLongitude =
        refrencePoint.longitude; // Longitude of the reference point
    double squareSize = size; // Size of the square area (in meters)

    double halfSize = squareSize / 2;

// Calculate coordinates for the square area
    double topLatitude = referenceLatitude +
        squareSize /
            111319.9; // 1 degree of latitude is approximately 111319.9 meters
    double bottomLatitude = referenceLatitude;
    double leftLongitude = referenceLongitude -
        halfSize /
            (111319.9 * 1 / math.cos(referenceLatitude * (math.pi / 180)));
    double rightLongitude = referenceLongitude +
        halfSize /
            (111319.9 * 1 / math.cos(referenceLatitude * (math.pi / 180)));

    return [
      LatLng(topLatitude, leftLongitude),
      LatLng(topLatitude, rightLongitude),
      LatLng(bottomLatitude, rightLongitude),
      LatLng(bottomLatitude, leftLongitude),
    ];
  }

  static bool checkPointInPolygon(LatLng point, List<LatLng> polygon) =>
      PolygonUtil.containsLocation(point, polygon, false);

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  static Future<String> getDeviceUdid() async {
    String udid = await FlutterUdid.udid;
    print('Device UDID: $udid');
    return udid;
  }

  static String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  static startAttendance(String subjectName, String facultyName) async {
    var subRef = dbRef.child('$subjectName/$facultyName');
    subRef.set({"attendance": []});
  }

  static updatePolyOnDb(
      List<LatLng> list, String subjectName, String facultyName) async {
    var subRef = dbRef.child('$subjectName/$facultyName');
    List<Map<String, dynamic>> jsonList = list.map((latLng) {
      return {
        "latitude": latLng.latitude,
        "longitude": latLng.longitude,
      };
    }).toList();
    await subRef.child('status').set({"status": "started"});
    await subRef.child('polygon').set(jsonList);
  }

  static markAttendance(
      Student student, String subjectName, String facultyName) async {
    var subRef = dbRef.child('$subjectName/$facultyName/attendance');
    final newData = {
      "name": student.name,
      "regNo": student.reg,
      "time": DateTime.now().toIso8601String()
    };
    subRef.push().set(newData);
  }

  static Future<List<LatLng>> getPolygonFromFirebase(
      String subjectName, String facultyName) async {
    List<LatLng> rectanglePoints = [];
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.once().then((e) {
      rectanglePoints = [];

      Map<dynamic, dynamic> values = e.snapshot.value as Map<dynamic, dynamic>;
      if (values != null) {
        values.forEach((key, value) {
          double latitude = value["latitude"];
          double longitude = value["longitude"];
          LatLng latLng = LatLng(latitude, longitude);
          rectanglePoints.add(latLng);
        });
      }

      // Now, `rectanglePoints` contains the list of LatLng values from Firebase.
    });
    return rectanglePoints;
  }
}
