import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String profileImage;
  final String username;
  final String bio;
  final List followers;
  final List following;

  const User(
      {required this.email,
      required this.uid,
      required this.profileImage,
      required this.username,
      required this.bio,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJson() => {
    'username': username,
    'uid': uid,
    'email': email,
    'bio': bio,
    'followers': followers,
    'following': following,
    'profile_image': profileImage,
  };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    print(snapshot);
    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      profileImage: snapshot["profile_image"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }
}
