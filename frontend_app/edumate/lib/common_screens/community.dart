import 'package:edumate/dataProvider/app_data.dart';
import 'package:edumate/helpers/firestore_helper.dart';
import 'package:edumate/model/comment.dart';
import 'package:edumate/model/faculty.dart';
import 'package:edumate/model/post.dart';
import 'package:edumate/model/student.dart';
import 'package:edumate/utils/app_color.dart';
import 'package:edumate/widgets/coin_dialog.dart';
import 'package:edumate/widgets/question_dialog.dart';
import 'package:edumate/widgets/uploadFile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class Community extends StatefulWidget {
  const Community({Key? key}) : super(key: key);

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  Stream<List<Post>>? _stream;
  final _key = GlobalKey<ExpandableFabState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _stream = FirestoreHelper.getPostStream();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppData>(context);
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<Post>>(
          stream: FirestoreHelper.getPostStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            print(snapshot.data);
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 12),
                      child: Card(
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 15),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        Text(
                                          data.name,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.blackColor),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(timeago.format(data.time))
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 17,
                                ),
                                Text(data.description),
                                SizedBox(
                                  height: 15,
                                ),
                                data.postType == PostType.document
                                    ? Column(
                                        children: [
                                          Container(
                                            height: 300,
                                            width: 300,
                                            child: Image.network(
                                                data.resourceLink!,
                                                fit: BoxFit.cover),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            CoinDialog(
                                                              post: data,
                                                            ));
                                                  },
                                                  icon: ImageIcon(
                                                    AssetImage(
                                                        'assets/coin.png'),
                                                    color:
                                                        AppColors.primaryColor,
                                                  )),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: ImageIcon(
                                                    AssetImage(
                                                        'assets/like.png'),
                                                    color:
                                                        AppColors.primaryColor,
                                                  )),
                                              SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          commentMethod(
                                              context,
                                              MediaQuery.of(context).size,
                                              data,
                                              data.name),
                                        ],
                                      )
                              ]),
                        ),
                      ),
                    );
                  });
            }
            return Container();
          },
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _key,
        // duration: const Duration(milliseconds: 500),
        // distance: 200.0,
        // type: ExpandableFabType.up,
        // pos: ExpandableFabPos.left,
        // childrenOffset: const Offset(0, 20),
        // fanAngle: 40,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.add),
          fabSize: ExpandableFabSize.regular,
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primaryColor,
          shape: const CircleBorder(),
          angle: 3.14 * 2,
        ),
        closeButtonBuilder: FloatingActionButtonBuilder(
          size: 56,
          builder: (BuildContext context, void Function()? onPressed,
              Animation<double> progress) {
            return IconButton(
              onPressed: onPressed,
              icon: const Icon(
                Icons.check_circle_outline,
                size: 40,
              ),
            );
          },
        ),
        overlayStyle: ExpandableFabOverlayStyle(
          // color: Colors.black.withOpacity(0.5),
          blur: 5,
        ),
        onOpen: () {
          debugPrint('onOpen');
        },
        afterOpen: () {
          debugPrint('afterOpen');
        },
        onClose: () {
          debugPrint('onClose');
        },
        afterClose: () {
          debugPrint('afterClose');
        },
        children: [
          FloatingActionButton.small(
            shape: CircleBorder(),
            backgroundColor: Color(0xFFFDFDFD),
            heroTag: null,
            child: const Icon(Icons.question_mark),
            onPressed: () {
              UserType userType = provider.getUserType;
              String name = "";
              String email = "";

              if (userType == UserType.student) {
                Student student = provider.getStudentDetails;
                name = student.name;
                email = student.email;
              } else if (userType == UserType.faculty) {
                Faculty faculty = provider.getFacultyDetails;
                name = faculty.facultyName;
                email = faculty.email;
              }
              showDialog(
                  context: context,
                  builder: (context) => QuestionDialog(
                        userType: userType,
                        name: name,
                        email: email,
                      ));
            },
          ),
          FloatingActionButton.small(
            shape: CircleBorder(),
            backgroundColor: Color(0xFFFDFDFD),
            // shape: const CircleBorder(),
            heroTag: null,
            child: const Icon(Feather.upload),
            onPressed: () {
              UserType userType = provider.getUserType;
              String name = "";
              String email = "";
              if (userType == UserType.student) {
                Student student = provider.getStudentDetails;
                name = student.name;
                email = student.email;
              } else if (userType == UserType.faculty) {
                Faculty faculty = provider.getFacultyDetails;
                name = faculty.facultyName;
                email = faculty.email;
              }
              showDialog(
                  context: context,
                  builder: (context) => UploadFileDialog(
                        userType: userType,
                        name: name,
                        email: email,
                      ));
            },
          ),
          FloatingActionButton.small(
            shape: CircleBorder(),
            backgroundColor: Color(0xFFFDFDFD),
            heroTag: null,
            child: ImageIcon(AssetImage('assets/doc.png')),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Padding commentMethod(
      BuildContext context, Size size, Post comp, String user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
          onPressed: () {
            showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                      4.0,
                    ),
                  ),
                ),
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  final TextEditingController modalCommentController =
                      TextEditingController();
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: SizedBox(
                      height: size.height * 0.7,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            StreamBuilder<List<CommentModel>>(
                              stream: FirestoreHelper.getCommentsStream(comp),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                snapshot.data![index].name,
                                                style: TextStyle(
                                                  fontSize: size.width * 0.043,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                DateFormat(
                                                        'dd-MM-yyyy – hh:mm a')
                                                    .format(snapshot
                                                        .data![index].dateTime)
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            snapshot.data![index].comment,
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                          SizedBox(height: 8),
                                        ],
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Divider();
                                    },
                                  );
                                }
                                return Container();
                              },
                            ),
                            const Spacer(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      hintText: "Add a comment...",
                                      border: InputBorder.none,
                                    ),
                                    controller: modalCommentController,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.send,
                                  ),
                                  onPressed: () {
                                    FirestoreHelper.addComment(
                                      comp.time.toIso8601String(),
                                      CommentModel(
                                          comment: modalCommentController.text,
                                          dateTime: DateTime.now(),
                                          name: user),
                                    );
                                  },
                                  padding: const EdgeInsets.all(15),
                                  color: Colors.blue,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          },
          icon: const ImageIcon(
            AssetImage('assets/comment.png'),
            color: AppColors.primaryColor,
          )),
    );
  }
}
