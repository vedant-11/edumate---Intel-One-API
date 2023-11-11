import 'dart:io';

import 'package:edumate/dataProvider/app_data.dart';
import 'package:edumate/helpers/cloud_helper.dart';
import 'package:edumate/helpers/firestore_helper.dart';
import 'package:edumate/model/post.dart';
import 'package:edumate/utils/app_color.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadFileDialog extends StatefulWidget {
  final String name;
  final String email;
  final UserType userType;
  const UploadFileDialog(
      {Key? key,
      required this.name,
      required this.email,
      required this.userType})
      : super(key: key);

  @override
  State<UploadFileDialog> createState() => _UploadFileDialogState();
}

class _UploadFileDialogState extends State<UploadFileDialog> {
  FilePickerResult? res;
  ResourceType? r;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Upload your File'),
                IconButton(
                    onPressed: () async {
                      res = await CloudHelper.pickFiles();
                      if (res!.files[0].name.endsWith('.pdf')) {
                        r = ResourceType.pdf;
                      } else {
                        r = ResourceType.image;
                      }
                      setState(() {});
                    },
                    icon: Icon(Icons.upload))
              ],
            ),
            (res != null)
                ? Text(
                    res!.files[0].name,
                    style: TextStyle(color: AppColors.blackColor),
                  )
                : SizedBox.shrink(),
            MaterialButton(
              minWidth: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              onPressed: () async {
                if (res != null) {
                  File file = File(res!.files.single.path!);
                  await CloudHelper.uploadToFirebase(
                      file, 'resources/${res!.files[0].name}');
                  var link = await CloudHelper.getDownloadLink(
                      'resources/${res!.files[0].name}');
                  await FirestoreHelper.uploadRes(
                      userType: widget.userType,
                      res: r!,
                      description: controller.text,
                      name: widget.name,
                      email: widget.email,
                      resLink: link!);
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
