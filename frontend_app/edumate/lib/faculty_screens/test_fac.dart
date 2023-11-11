import 'package:edumate/helpers/data_helper.dart';
import 'package:edumate/helpers/firestore_helper.dart';
import 'package:edumate/model/question.dart';
import 'package:edumate/utils/app_color.dart';
import 'package:flutter/material.dart';

class TestFac extends StatefulWidget {
  const TestFac({Key? key}) : super(key: key);

  @override
  State<TestFac> createState() => _TestFacState();
}

var elements = ['EASY', 'INTERMEDIATE', 'HARD'];

class _TestFacState extends State<TestFac> {
  final topicName = TextEditingController();
  final duration = TextEditingController();

  var dropdownvalue = elements[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Make Quick Test',
              style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 25,
            ),
            TextField(
              cursorColor: AppColors.primaryColor,
              controller: topicName,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primaryColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primaryColor)),
                labelText: 'Topic Name',
                labelStyle:
                    TextStyle(fontSize: 14, color: AppColors.blackColor),
                hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
              ),
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 25,
            ),
            TextField(
              cursorColor: AppColors.primaryColor,
              controller: duration,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primaryColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primaryColor)),
                labelText: 'Duration',
                labelStyle:
                    TextStyle(fontSize: 14, color: AppColors.blackColor),
                hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
              ),
              style: TextStyle(fontSize: 14),
            ),
            Container(
              child: Row(
                children: [
                  Text(
                    'Select Level',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  DropdownButton(
                    // Initial Value
                    value: dropdownvalue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: elements.map((items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (newValue) {
                      setState(() {
                        dropdownvalue = newValue as String;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              minWidth: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              onPressed: () async {
                DataHelper dataHelper = DataHelper();
                List<Question> ques =
                    await dataHelper.generateTest(topicName.text);
                await FirestoreHelper.updateQuiz(ques, topicName.text);
              },
              child: Text(
                'Create Test',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              color: AppColors.secondaryColor,
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
