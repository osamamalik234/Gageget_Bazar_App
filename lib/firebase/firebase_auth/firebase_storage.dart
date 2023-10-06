import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper {
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  // upload image in Firebase Storage and get URL
  Future<String> uploadImage(Uint8List image) async {
    String userId = _auth.currentUser!.uid;
    TaskSnapshot uploadTask = await _firebaseStorage.ref(userId).putData(image);
    String imageUrl = await uploadTask.ref.getDownloadURL();
    return imageUrl;
  }
}
