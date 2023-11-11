// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:edumate/dataProvider/app_data.dart';

import 'comment_list.dart';

enum PostType { question, document }

enum ResourceType { image, pdf }

class Post {
  String name;
  PostType postType;
  ResourceType? resourceType;
  String? resourceLink;
  String description;
  DateTime time;
  List<String>? upvotes;
  CommentListModel? comments;
  String email;
  UserType userType;
  Post(
      {required this.name,
      required this.postType,
      this.resourceType,
      this.resourceLink,
      required this.description,
      required this.time,
      this.upvotes,
      this.comments,
      required this.email,
      required this.userType});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'postType': postType.index,
      'resourceType': resourceType?.index,
      'resourceLink': resourceLink,
      'description': description,
      'time': time.millisecondsSinceEpoch,
      'upvotes': upvotes,
      'comments': comments?.toMap(),
      'email': email,
      'userType': userType.index
    };
  }

  factory Post.fromMap(map1) {
    var map = map1.data();
    return Post(
        name: map['name'] as String,
        postType: PostType.values[(map['postType'])],
        resourceType: map['resourceType'] != null
            ? ResourceType.values[(map['resourceType'])]
            : null,
        resourceLink:
            map['resourceLink'] != null ? map['resourceLink'] as String : null,
        description: map['description'] as String,
        time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
        upvotes:
            map['upvotes'] != null ? List.from((map['upvotes'] as List)) : null,
        comments: CommentListModel.getComplaints(map1.id),
        email: map['email'] as String,
        userType: UserType.values[(map['userType'])]);
  }
}
