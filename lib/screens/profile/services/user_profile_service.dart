import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:guitar_app/common/helpers.dart';
import 'package:guitar_app/entities/app_user.dart';
import 'package:guitar_app/entities/profile_picture.dart';
import 'package:guitar_app/screens/profile/services/media_service.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileService {
  static Future<AppUser> getUserById(String documentId) async {
    var firestore = FirebaseFirestore.instance;
    var usersCollection = firestore.collection('users');

    var documentSnapshot = await usersCollection.doc(documentId).get();

    if (documentSnapshot.exists) {
      return AppUser.fromMap(
          documentId, documentSnapshot.data() as Map<String, dynamic>);
    } else {
      throw Exception('User not found');
    }
  }

  static Future<AppUser> getUserByNickname(String nickname) async {
    var firestore = FirebaseFirestore.instance;
    var usersCollection = firestore.collection('users');

    var querySnapshot =
        await usersCollection.where('name', isEqualTo: nickname).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      var userDoc = querySnapshot.docs.first;
      return AppUser.fromMap(
          userDoc.id, userDoc.data() as Map<String, dynamic>);
    } else {
      throw Exception('User not found');
    }
  }

  static Future<String?> changeProfilePicture(context) async {
    ProfilePicture? profilePic =
        await MediaService.getCroppedImageFromStorage(context);
    if (profilePic == null) {
      return null;
    }
    final storageRef = FirebaseStorage.instance.ref();
    final destinationReference =
        storageRef.child("/profile_pictures/${DateTime.timestamp()}");
    final uploadFile = await profilePic.imageFile.readAsBytes();
    await destinationReference.putData(uploadFile);

    String downloadURL = await destinationReference.getDownloadURL();
    final collection = FirebaseFirestore.instance.collection('users');
    collection
        .doc(context.widget.user.id)
        .update({'picture': downloadURL})
        .then((_) => print('Successfully added new pictureURL to user'))
        .catchError((error) => print('Failed: $error'));
    return downloadURL;
  }
}
