import 'package:edumate/dataProvider/app_data.dart';
import 'package:edumate/model/post.dart';
import 'package:edumate/utils/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CoinDialog extends StatefulWidget {
  final Post post;
  const CoinDialog({Key? key, required this.post}) : super(key: key);

  @override
  State<CoinDialog> createState() => _CoinDialogState();
}

class _CoinDialogState extends State<CoinDialog> {
  addPointToRec(String email, int point, UserType userType1) async {
    int atIndex = email.indexOf("@");

    // Extract the part before the "@" symbol
    String path = email.substring(0, atIndex);
    DatabaseReference newUserRef1 = FirebaseDatabase.instance.ref().child(
        '${userType1 == UserType.faculty ? 'Faculties' : 'Students'}/$path');

    var snapshot = await newUserRef1.once();
    Map<dynamic, dynamic> atts = snapshot.snapshot.value as dynamic;
    var p = atts['points'] as int;
    var updateNo1 = p + point;
    await newUserRef1.update({'points': updateNo1});
  }

  var controller = TextEditingController();
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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              cursorColor: AppColors.primaryColor,
              controller: controller,
              keyboardType: TextInputType.number,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primaryColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primaryColor)),
                labelText: 'How many points you want to give',
                labelStyle:
                    TextStyle(fontSize: 14, color: AppColors.blackColor),
                hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
              ),
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 35,
            ),
            MaterialButton(
              minWidth: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              onPressed: () async {
                var no = int.parse(controller.text);
                var snapshot = await newUserRef.once();
                Map<dynamic, dynamic> atts = snapshot.snapshot.value as dynamic;
                var p = atts['points'] as int;

                if (p < no) {
                  Fluttertoast.showToast(
                      msg: "You have insufficient coins",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 16.0);
                } else {
                  int updateNo = p - no;
                  await newUserRef.update({'points': updateNo});

                  await addPointToRec(
                      widget.post.email, no, widget.post.userType);
                }
              },
              child: Text(
                'Submit',
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
          ],
        ),
      ),
    );
  }
}
