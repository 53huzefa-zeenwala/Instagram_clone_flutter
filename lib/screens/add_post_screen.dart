import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_with_android/reponsive/firestore_method.dart';
import 'package:project_with_android/utils/utils.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';
import '../utils/colors.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Create a Post'),
        children: [
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: Text('Take a photo'),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.camera);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: Text('Choose from gallery'),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(null);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  void postImage(String uid) async {
    setState(() {
      isLoading = true;
    });
    String res = await FirestoreMethod().uploadPost(description: _descriptionController.text, file: _file!, uid: uid);
    setState(() {
      isLoading = false;
    });
    if (res == "Success") {
      clearImage();
      showSnackbar('Posted', context);
    } else {
      showSnackbar(res, context);
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
              ),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text(
                'Post to',
              ),
              centerTitle: false,
              actions: <Widget>[
                TextButton(

                  onPressed: () => postImage(
                    userProvider.getUser!.uid,
                  ),
                  child: const Text(
                    "Post",
                    style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                )
              ],
            ),
            // POST FORM
            body:   Column(
              children: <Widget>[
                isLoading ? const LinearProgressIndicator() : const Padding(padding: EdgeInsets.only(top: 0.0)),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 60,
                        child: Center(
                          child: CircleAvatar(
                            backgroundImage: userProvider.getUser?.profileImage != null
                                ? NetworkImage(
                                    userProvider.getUser!.profileImage,
                                  )
                                : NetworkImage('https://th.bing.com/th/id/OIP.6UhgwprABi3-dz8Qs85FvwHaHa?rs=1&pid=ImgDetMain'),
                          ),
                        ),
                      ),
                      Expanded(
                        // width: MediaQuery.of(context).size.width * 0.3,
                        child: TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(hintText: "Write a caption...", border: InputBorder.none),
                          maxLines: 8,
                        ),
                      ),
                      Container(
                        width: 90.0,
                        height: 90,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          fit: BoxFit.contain,
                          alignment: FractionalOffset.topCenter,
                          image: MemoryImage(_file!),
                        )),
                      ),
                    ],
                  ),
                ),
                const Divider(),
              ],
            ),
          );
  }
}
