import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edumate/dataProvider/app_data.dart';
import 'package:edumate/model/comment.dart';
import 'package:edumate/model/question.dart';

import '../model/post.dart';

class FirestoreHelper {
  static askQuestion(
      {required String question,
      required String name,
      required UserType userType,
      required String email}) async {
    var time = DateTime.now();
    Post post = Post(
        name: name,
        postType: PostType.question,
        email: email,
        description: question,
        time: time,
        userType: userType,
        comments: null);

    var postRef = await FirebaseFirestore.instance
        .collection('posts')
        .doc(time.toIso8601String())
        .set(post.toMap())
        .then((value) => print("Post Added"))
        .catchError((error) => print("Failed to add post: $error"));
  }

  static uploadRes(
      {required String description,
      required String name,
      required UserType userType,
      required String email,
      required String resLink,
      required ResourceType res}) async {
    var time = DateTime.now();
    Post post = Post(
        userType: userType,
        name: name,
        postType: PostType.document,
        description: description,
        time: time,
        email: email,
        resourceType: res,
        resourceLink: resLink,
        upvotes: []);
    var postRef = await FirebaseFirestore.instance
        .collection('posts')
        .doc(time.toIso8601String())
        .set(post.toMap())
        .then((value) => print("Post Added"))
        .catchError((error) => print("Failed to add post: $error"));
  }

  static Stream<List<Post>> getPostStream() {
    Stream<QuerySnapshot> complaintRefStream = FirebaseFirestore.instance
        .collection("posts")
        .orderBy('time', descending: true)
        .snapshots();

    List<Post> postList = [];
    return complaintRefStream.map((qshot) {
      return qshot.docs.map((doc) {
        var post = Post.fromMap(doc);
        print('post: ${post.toMap()}');
        return post;
      }).toList();
    });
  }

  static addComment(String postId, CommentModel comment) async {
    CollectionReference commentRef = FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("comments");
    return commentRef
        .doc(comment.dateTime.toString())
        .set(comment.toMap())
        .then((value) {
      // print(comment.toMap());
      print("Comment Added");
    }).catchError((error) => print("Failed to add comment: $error"));
  }

  static Stream<List<CommentModel>> getCommentsStream(Post post) {
    var stream = FirebaseFirestore.instance
        .collection("posts")
        .doc(post.time.toIso8601String())
        .collection("comments")
        .orderBy('dateTime', descending: true)
        .snapshots();
    return stream.map((qshot) {
      return qshot.docs.map((doc) {
        // print(doc.data());

        return CommentModel.fromMap(doc);
      }).toList();
    });
  }

  static updateQuiz(List<Question> ques, String topic) async {
    var d = ques.map((e) => e.toMap()).toList();
    var postRef = await FirebaseFirestore.instance
        .collection(topic)
        .doc('Kalpana')
        .set({"questions1": d})
        .then((value) => print("Post Added"))
        .catchError((error) => print("Failed to add post: $error"));
    await FirebaseFirestore.instance
        .collection('collName')
        .doc("collName")
        .set({"collName": topic});
  }

  static Future<String> getTopic() async {
    String topic = '';
    var doc2 = await FirebaseFirestore.instance
        .collection('collName')
        .doc("collName")
        .get();
    if (doc2.exists) {
      Map<dynamic, dynamic> doc1 = doc2.data() as dynamic;
      final collName = doc1['collName'];
      topic = collName;
    }
    return topic;
  }

  static Future<List<Question>> getQuiz(String topic) async {
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection(topic)
        .doc(
            'Kalpana') // Replace 'your_document_id' with the actual document ID
        .get();

    if (doc.exists) {
      Map<dynamic, dynamic> doc1 = doc.data() as dynamic;
      final List<dynamic> questionList = doc1['questions1'] ?? [];
      List<Question> questions =
          questionList.map((data) => Question.fromMap(data)).toList();
      return questions;
    } else {
      print('Document does not exist');
      return [];
    }
  }
}
