// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Student {
  String id;
  int semester;
  String reg;
  String name;
  String email;
  String section;
  String phone;
  int points;
  Student({
    required this.id,
    required this.semester,
    required this.reg,
    required this.name,
    required this.email,
    required this.section,
    required this.phone,
    required this.points,
  });

  Student copyWith({
    String? id,
    int? semester,
    String? reg,
    String? name,
    String? email,
    String? section,
    String? phone,
    int? points,
  }) {
    return Student(
      id: id ?? this.id,
      semester: semester ?? this.semester,
      reg: reg ?? this.reg,
      name: name ?? this.name,
      email: email ?? this.email,
      section: section ?? this.section,
      phone: phone ?? this.phone,
      points: points ?? this.points,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'semester': semester,
      'reg': reg,
      'name': name,
      'email': email,
      'section': section,
      'phone': phone,
      'points': points,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['_id'] as String,
      semester: map['semester'] as int,
      reg: map['reg'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      section: map['section'] as String,
      phone: map['phone'].toString(),
      points: map['points'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) =>
      Student.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Student(id: $id, semester: $semester, reg: $reg, name: $name, email: $email, section: $section, phone: $phone, points: $points)';
  }

  @override
  bool operator ==(covariant Student other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.semester == semester &&
        other.reg == reg &&
        other.name == name &&
        other.email == email &&
        other.section == section &&
        other.phone == phone &&
        other.points == points;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        semester.hashCode ^
        reg.hashCode ^
        name.hashCode ^
        email.hashCode ^
        section.hashCode ^
        phone.hashCode ^
        points.hashCode;
  }
}
