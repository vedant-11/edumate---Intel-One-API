import 'dart:async';

import 'package:edumate/helpers/cloud_helper.dart';
import 'package:edumate/model/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../dataProvider/quiz_ques_provider.dart';
import '../model/question.dart';

class QuizQues extends StatefulWidget {
  final Test test;
  static const name = 'quizscreen';
  const QuizQues({Key? key, required this.test}) : super(key: key);

  @override
  State<QuizQues> createState() => _QuizQuesState();
}

class _QuizQuesState extends State<QuizQues> {
  Test? quizData;
  int _currentQuestionIndex = 0;
  String? _markedAnswer;
  Question? currentQues;

  Timer? countDownTimer;
  Duration? testDuration;

  int _groupValue = 0;

  QuizData? quizProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quizData = widget.test;
    _currentQuestionIndex =
        Provider.of<QuizData>(context, listen: false).getCurentQuesIndex();
    testDuration = Duration(minutes: 7);
    quizProvider = Provider.of<QuizData>(context, listen: false);

    _groupValue = 0;
    startTimer();
  }

  void markAnswer(String answer) {
    Question currentQues = quizData!.questions[_currentQuestionIndex];
    if (currentQues.answers.contains(answer)) {
      setState(() {
        currentQues.markedAnswer = answer;
      });
    }
  }

  void onchangedAnswer(val) {
    setState(() {
      _groupValue = val;
    });
    quizProvider!.markAnswer(val);
  }

  void startTimer() {
    countDownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setCountDown();
    });
  }

  void stopTimer() {
    countDownTimer!.cancel();
  }

  void resetTimer(Duration duration) {
    stopTimer();
    setState(() {
      testDuration = duration;
    });
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    final seconds = testDuration!.inSeconds - reduceSecondsBy;

    setState(() {
      seconds < 0
          ? countDownTimer!.cancel()
          : testDuration = Duration(seconds: seconds);
      print(testDuration);
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<QuizData>(context);
    var marked =
        quizData!.questions[provider.getCurentQuesIndex()].markedAnswer ??
            quizData!.questions![provider.getCurentQuesIndex()].answers[0];

    _groupValue = quizData!.questions[provider.getCurentQuesIndex()].answers
        .indexOf(marked);

    var textColor = Color(0xFF202020);
    currentQues = quizData!.questions[provider.getCurentQuesIndex()];
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Test - ${quizData!.name} (${quizData!.id})',
                    style: GoogleFonts.poppins(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 19, vertical: 13),
                    decoration: BoxDecoration(
                        color: Color(0xFF41B694),
                        borderRadius: BorderRadius.circular(10)),
                    width: 0.915 * width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          // width: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Fontisto.clock,
                                color: Colors.black,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Time Remaining',
                                style: GoogleFonts.poppins(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Text(CloudHelper.printDuration(testDuration!),
                            style: GoogleFonts.poppins(color: Colors.black))
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 32),
                    child: Text(
                      'Question ${_currentQuestionIndex + 1}',
                      style: GoogleFonts.poppins(color: Color(0xFF707070)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 9),
                    child: Text(
                      currentQues!.question,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: textColor),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 32),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: currentQues!.answers.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            onchangedAnswer(index);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              color: const Color(0xFFF3F3F3),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                    activeColor: Theme.of(context).primaryColor,
                                    value: index,
                                    groupValue: _groupValue,
                                    onChanged: onchangedAnswer),
                                Expanded(
                                  child: Text(currentQues!.answers[index],
                                      style: TextStyle()),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          provider.prevQuestion();
                        },
                        child: Row(children: [
                          Icon(
                            Entypo.chevron_small_left,
                            color: Theme.of(context).primaryColor,
                            size: 21,
                          ),
                          Text('Previous',
                              // gradient: const LinearGradient(
                              //   colors: [
                              //     Color(0xFF8A5BEF),
                              //     Color(0xFF5866DE)
                              //   ],
                              // ),
                              style: GoogleFonts.poppins(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18))
                        ]),
                      ),
                      TextButton(
                        onPressed: () {
                          print("next");
                          print(_currentQuestionIndex);
                          print(quizData!.questions.length - 1);
                          provider.nextQuestion();
                        },
                        child: Row(children: [
                          Text(
                              (provider.getCurentQuesIndex() ==
                                      (quizData!.questions.length - 1))
                                  ? 'Submit'
                                  : 'Next',
                              // gradient: const LinearGradient(
                              //   colors: [
                              //     Color(0xFF8A5BEF),
                              //     Color(0xFF5866DE)
                              //   ],
                              // ),
                              style: GoogleFonts.poppins(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18)),
                          Icon(
                            Entypo.chevron_small_right,
                            color: Theme.of(context).primaryColor,
                            size: 21,
                          ),
                        ]),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
