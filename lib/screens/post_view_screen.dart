import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_with_android/model/post.dart';
import 'package:project_with_android/reponsive/firestore_method.dart';
import 'package:project_with_android/utils/colors.dart';
import 'package:project_with_android/utils/utils.dart';
import 'package:project_with_android/widgets/post_card.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import '../provider/user_provider.dart';
import '../widgets/comment_card.dart';

class PostViewScreen extends StatefulWidget {
  final String postId;
  const PostViewScreen({super.key, required this.postId});

  @override
  State<PostViewScreen> createState() => _PostViewScreenState();
}

class _PostViewScreenState extends State<PostViewScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text('Post'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Posts').doc(widget.postId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var res = Post.fromSnap(snapshot.data!);
          return SingleChildScrollView(
            child: PostCard(
              post: res,
            ),
          );
        },
      ),
    );
  }
}
