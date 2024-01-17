import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_with_android/model/post.dart';
import 'package:project_with_android/reponsive/firestore_method.dart';
import 'package:project_with_android/screens/comment_screen.dart';
import 'package:project_with_android/utils/colors.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import '../provider/user_provider.dart';
import '../utils/utils.dart';
import 'like_animation.dart';

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  bool showFullDescription = false;
  var countFormat = NumberFormat.compact(locale: 'en_us');
  User? userDetails;
  int commentLen = 0;

  @override
  void initState() {
    Future.wait([getUser(widget.post.uid), fetchCommentLen()]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: 500),
        // width: double.infinity,
        // alignment: Alignment.center,
        color: mobileBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 16,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(userDetails?.profileImage ??
                        'https://images.unsplash.com/photo-1704213029686-ad1f1d54130b?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                      ),
                      child: Text(
                        userDetails?.username ?? 'Username',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                children: ['Delete']
                                    .map(
                                      (e) => InkWell(
                                        onTap: () {},
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                          child: Text(e),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.more_vert))
                ],
              ),
            ),
            GestureDetector(
              onDoubleTap: () {
                FirestoreMethod().likePost(widget.post.postId.toString(), user!.uid, widget.post.likes, widget.post.likesCount);
                setState(() {
                  isLikeAnimating = true;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(maxHeight: 500),
                    width: double.infinity,
                    child: Image.network(
                      fit: BoxFit.cover,
                      widget.post.postUrl,
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                      isAnimating: isLikeAnimating,
                      duration: const Duration(
                        milliseconds: 400,
                      ),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                LikeAnimation(
                  isAnimating: widget.post.likes.contains(user?.uid),
                  smallLike: true,
                  child: IconButton(
                    icon: widget.post.likes.contains(user?.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                          ),
                    onPressed: () => FirestoreMethod().likePost(widget.post.postId.toString(), user!.uid, widget.post.likes, widget.post.likesCount),
                  ),
                ),
                IconButton(
                    onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CommentScreen(
                              postId: widget.post.postId.toString(),
                            ),
                          ),
                        ),
                    icon: Icon(
                      Icons.comment_outlined,
                      color: Colors.white,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border),
                  ),
                ))
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      '${countFormat.format(widget.post.likesCount)} likes',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        showFullDescription = !showFullDescription;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 8),
                      child: RichText(
                        maxLines: showFullDescription ? 100 : 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(style: const TextStyle(color: primaryColor), children: [
                          TextSpan(
                            text: userDetails?.username ?? 'UserName',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '  ${widget.post.description}',
                          ),
                        ]),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'View all $commentLen comments',
                        style: TextStyle(
                          fontSize: 15,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                    ),
                    child: Text(
                      TimeFormatter.getPostTime(widget.post.datePublished),
                      style: const TextStyle(fontSize: 13, color: secondaryColor),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getUser(String uid) async {
    var data = await FirestoreMethod().getUser(uid);
    if (data != null) {
      setState(() {
        userDetails = data;
      });
    }
  }

  Future<void> fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance.collection('Posts').doc(widget.post.postId).collection('comments').get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackbar(
        err.toString(),
        context,
      );
    }
    setState(() {});
  }
}
