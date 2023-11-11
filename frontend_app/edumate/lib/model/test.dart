// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'question.dart';

class Test {
  String id;
  String name;
  Duration duration;
  List<Question> questions = [];
  int totalMarks;
  int? marksObtained;
  Test({
    required this.id,
    required this.name,
    required this.duration,
    required this.questions,
    required this.totalMarks,
    this.marksObtained,
  });

  Test copyWith({
    String? id,
    String? name,
    Duration? duration,
    List<Question>? questions,
    int? totalMarks,
    int? marksObtained,
  }) {
    return Test(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      questions: questions ?? this.questions,
      totalMarks: totalMarks ?? this.totalMarks,
      marksObtained: marksObtained ?? this.marksObtained,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'duration': duration.inSeconds,
      'questions': questions.map((x) => x.toMap()).toList(),
      'totalMarks': totalMarks,
      'marksObtained': marksObtained,
    };
  }

  factory Test.fromMap(Map<String, dynamic> map) {
    return Test(
      id: map['id'] as String,
      name: map['name'] as String,
      duration: Duration(seconds: map['duration']),
      questions: List<Question>.from(
        (map['questions'] as List<int>).map<Question>(
          (x) => Question.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalMarks: map['totalMarks'] as int,
      marksObtained:
          map['marksObtained'] != null ? map['marksObtained'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Test.fromJson(String source) =>
      Test.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Test(id: $id, name: $name, duration: $duration, questions: $questions, totalMarks: $totalMarks, marksObtained: $marksObtained)';
  }

  @override
  bool operator ==(covariant Test other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.duration == duration &&
        listEquals(other.questions, questions) &&
        other.totalMarks == totalMarks &&
        other.marksObtained == marksObtained;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        duration.hashCode ^
        questions.hashCode ^
        totalMarks.hashCode ^
        marksObtained.hashCode;
  }
}
