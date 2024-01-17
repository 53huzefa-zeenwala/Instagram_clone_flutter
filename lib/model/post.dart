import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final List likes;
  final int likesCount;
  final String? postId;
  final DateTime datePublished;
  final String postUrl;

  const Post({
    required this.description,
    required this.likesCount,
    required this.uid,
    required this.likes,
    this.postId,
    required this.datePublished,
    required this.postUrl,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot["description"],
      likesCount: snapshot["likesCount"],
      uid: snapshot["uid"],
      likes: snapshot["likes"],
      postId: snap.id,
      datePublished: (snapshot["datePublished"] as Timestamp).toDate(),
      postUrl: snapshot['postUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "likesCount": likesCount,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
      };

  @override
  String toString() {
    return {
      "description": description,
      "uid": uid,
      "likes": likes,
      "likesCount": likesCount,
      "postId": postId,
      "datePublished": datePublished,
      'postUrl': postUrl,
    }.toString();
  }
}
