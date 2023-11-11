import 'package:edumate/model/question.dart';
import 'package:edumate/model/test.dart';

List<Question> questions = <Question>[
  Question(
    id: '1',
    question: 'Which of the following cannot be polarised?',
    answers: ['Radiowaves', 'Transverse waves', 'Sound waves', 'X-Rays'],
  ),
  Question(
    id: '2',
    question: 'Which of the  cannot be polarised?',
    answers: ['Radiowaves', 'Transverse waves', 'Sound waves', 'X-Rays'],
  )
];

Test quizData = Test(
    totalMarks: 50,
    id: 'PY123978',
    name: 'Physics',
    duration: Duration(minutes: 15),
    questions: questions);
