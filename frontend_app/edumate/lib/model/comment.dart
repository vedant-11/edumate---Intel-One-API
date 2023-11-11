// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CommentModel {
  String comment;
  DateTime dateTime;
  String name;
  CommentModel({
    required this.comment,
    required this.dateTime,
    required this.name,
  });

  CommentModel copyWith({
    String? comment,
    DateTime? dateTime,
    String? user,
  }) {
    return CommentModel(
      comment: comment ?? this.comment,
      dateTime: dateTime ?? this.dateTime,
      name: user ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'comment': comment,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'user': name,
    };
  }

  factory CommentModel.fromMap(map) {
    return CommentModel(
      comment: map['comment'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      name: map['comment'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CommentModel(comment: $comment, dateTime: $dateTime, user: $name)';

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;

    return other.comment == comment &&
        other.dateTime == dateTime &&
        other.name == name;
  }

  @override
  int get hashCode => comment.hashCode ^ dateTime.hashCode ^ name.hashCode;
}
