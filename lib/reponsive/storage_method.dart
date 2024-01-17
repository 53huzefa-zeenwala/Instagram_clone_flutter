import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethod {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImagetoStorage(String childName, Uint8List file, bool isPost) async {

    var ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if (isPost) {
      ref = ref.child(DateTime.now().toString());
    }

    var uploadTask = ref.putData(file);

    var snap = await uploadTask;

    var downloadUrl = snap.ref.getDownloadURL();

    return downloadUrl;
  }


}