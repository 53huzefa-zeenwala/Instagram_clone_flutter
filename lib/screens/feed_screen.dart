import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_with_android/utils/colors.dart';
import 'package:project_with_android/utils/global_variable.dart';
import 'package:project_with_android/widgets/post_card.dart';

import '../model/post.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 32,
              ),
              actions: [IconButton(onPressed: () {}, icon: Icon(Icons.message_outlined))],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(
              'Posts',
            )
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Checking if the snapshot has any data or not
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }

          // means connection to future hasnt been made yet
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          final res = snapshot.data?.docs.map((e) => Post.fromSnap(e)).toList() ?? [];

          return ListView.builder(
            itemCount: res.length,
            itemBuilder: (context, index) => PostCard(
              post: res[index],
            ),
          );
        },
      ),
    );
  }
}
