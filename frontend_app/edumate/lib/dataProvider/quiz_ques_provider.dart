import 'package:flutter/cupertino.dart';

import '../data/quiz_data.dart';
import '../model/question.dart';

class QuizData extends ChangeNotifier {
  Question? _question;
  int _currentQuesIndex = 0;

  Question getQuestion() => quizData.questions[_currentQuesIndex];
  int getCurentQuesIndex() => _currentQuesIndex;

  void setCurrentQuesIndex(int val) {
    print("val: $val");
    if (val > 0 && val < quizData.questions.length) {
      _currentQuesIndex = val;
      notifyListeners();
    }
  }

  void markAnswer(index) {
    Question currentQues = quizData.questions[_currentQuesIndex];
    currentQues.markedAnswer = currentQues.answers[index];
    notifyListeners();
  }

  void nextQuestion() {
    if (quizData.questions.length > _currentQuesIndex + 1) {
      _currentQuesIndex = _currentQuesIndex + 1;
    } else {}
  }

  void prevQuestion() {
    if (_currentQuesIndex - 1 >= 0) {
      _currentQuesIndex = _currentQuesIndex - 1;
    }
  }
}
