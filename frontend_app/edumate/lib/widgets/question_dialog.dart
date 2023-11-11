// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:edumate/dataProvider/app_data.dart';
import 'package:edumate/helpers/data_helper.dart';
import 'package:edumate/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../helpers/firestore_helper.dart';

class QuestionDialog extends StatefulWidget {
  final String name;
  final String email;
  final UserType userType;

  const QuestionDialog({
    Key? key,
    required this.name,
    required this.email,
    required this.userType,
  }) : super(key: key);

  @override
  State<QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog> {
  var controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primaryColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primaryColor)),
                labelText: 'Enter your question',
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
                DataHelper data = DataHelper();
                bool res = await data.getSentiment(controller.text);
                if (res == true) {
                  await FirestoreHelper.askQuestion(
                      userType: widget.userType,
                      question: controller.text,
                      name: widget.name,
                      email: widget.email);
                } else {
                  Fluttertoast.showToast(
                      msg: "Please Write an appropriate question",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 16.0);
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
