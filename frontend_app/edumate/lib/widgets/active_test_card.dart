import 'package:edumate/helpers/firestore_helper.dart';
import 'package:edumate/model/test.dart';
import 'package:edumate/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dataProvider/quiz_ques_provider.dart';
import '../student_screens/quiz.dart';

class ActiveTestCard extends StatelessWidget {
  String courseCode;
  String chapter;
  String date;
  String time;
  String faculty;
  int maxMarks;
  double width;

  ActiveTestCard({
    required this.courseCode,
    required this.chapter,
    required this.date,
    required this.time,
    required this.faculty,
    required this.maxMarks,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 2,
            offset: const Offset(0, 2),
          )
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            courseCode,
            style: TextStyle(
              color: Color(0xff107ABE),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            chapter,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xff555555),
            ),
          ),
          const SizedBox(height: 24),
          RichText(
            text: TextSpan(
              text: "Teacher: ",
              style: TextStyle(
                color: Color(0xff2F2F2F),
                fontSize: 14,
              ),
              children: [
                TextSpan(
                  text: faculty,
                  style: TextStyle(
                    color: Color(0xff2F2F2F),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    color: Color(0xff8F8F8F),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    date,
                    style: TextStyle(
                      color: Color(0xff2F2F2F),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    color: Color(0xff8F8F8F),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    time,
                    style: TextStyle(
                      color: Color(0xff2F2F2F),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.done_outline,
                    color: Color(0xff8F8F8F),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    maxMarks.toString() + " Marks",
                    style: TextStyle(
                      color: Color(0xff2F2F2F),
                      fontSize: 14,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () async {
              String topic = await FirestoreHelper.getTopic();
              var ques = await FirestoreHelper.getQuiz(topic);
              Test test = Test(
                  id: '${topic}12',
                  name: topic,
                  duration: Duration(minutes: 7),
                  questions: ques,
                  totalMarks: ques.length * 10);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider(
                              create: (context) => QuizData()),
                        ],
                        child: QuizQues(
                          test: test,
                        ),
                      )),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              width: width,
              child: Text(
                "START TEST",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              // width: double.in
              decoration: const BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
