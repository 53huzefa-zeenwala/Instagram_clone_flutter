import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:project_with_android/model/user.dart';
import 'package:project_with_android/screens/post_view_screen.dart';
import '../model/post.dart';
import 'profile_screen.dart';
import '../../utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Form(
          child: TextFormField(
            controller: searchController,
            style: TextStyle(fontSize: 14),
            decoration: const InputDecoration
              (
              contentPadding: EdgeInsets.zero,
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
              constraints: BoxConstraints(maxHeight: 40),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
            },
          ),
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var data = snapshot.data!;

                var res = data.docs.map((e) => User.fromSnap(e)).toList();

                return ListView.builder(
                  itemCount: res.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            uid: res[index].uid,
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            res[index].profileImage,
                          ),
                          radius: 16,
                        ),
                        title: Text(
                          res[index].username,
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('Posts').orderBy('datePublished').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var data = snapshot.data!;

                var res = data.docs.map((e) => Post.fromSnap(e)).toList();

                return MasonryGridView.count(
                  crossAxisCount: 3,
                  itemCount: res.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PostViewScreen(
                          postId: res[index].postId!,
                        ),
                      ),
                    ),
                    child: Image.network(
                      res[index].postUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );
              },
            ),
    );
  }
}
