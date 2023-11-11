// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Faculty {
  String id;
  String facultyName;
  String fn;
  String email;

  String subjectName;
  String section;
  Faculty({
    required this.id,
    required this.facultyName,
    required this.fn,
    required this.email,
    required this.subjectName,
    required this.section,
  });

  Faculty copyWith({
    String? id,
    String? facultyName,
    String? fn,
    String? email,
    String? subjectName,
    String? section,
  }) {
    return Faculty(
      id: id ?? this.id,
      facultyName: facultyName ?? this.facultyName,
      fn: fn ?? this.fn,
      email: email ?? this.email,
      subjectName: subjectName ?? this.subjectName,
      section: section ?? this.section,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'facultyName': facultyName,
      'fn': fn,
      'email': email,
      'subjectName': subjectName,
      'section': section,
    };
  }

  factory Faculty.fromMap(Map<String, dynamic> map) {
    return Faculty(
      id: map['_id'] as String,
      facultyName: map['facultyName'] as String,
      fn: map['fn'] as String,
      email: map['email'] as String,
      subjectName: map['subjectName'] as String,
      section: map['section'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Faculty.fromJson(String source) =>
      Faculty.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Faculty(_id: $id, facultyName: $facultyName, fn: $fn, email: $email, subjectName: $subjectName, section: $section)';
  }

  @override
  bool operator ==(covariant Faculty other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.facultyName == facultyName &&
        other.fn == fn &&
        other.email == email &&
        other.subjectName == subjectName &&
        other.section == section;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        facultyName.hashCode ^
        fn.hashCode ^
        email.hashCode ^
        subjectName.hashCode ^
        section.hashCode;
  }
}
