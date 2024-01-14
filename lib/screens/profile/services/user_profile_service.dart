import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:guitar_app/entities/app_user.dart';
import 'package:guitar_app/entities/preview_data.dart';
import 'package:guitar_app/entities/profile_picture.dart';
import 'package:guitar_app/entities/songs.dart';
import 'package:guitar_app/screens/profile/services/media_service.dart';

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
      return AppUser.fromMap(userDoc.id, userDoc.data());
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

  static Future<List<Song>> getUserFavoritesPreview(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    List<String> songIds;
    if (userDoc.exists && userDoc.data()!['favorites'] is List) {
      // Return the list of favorite song IDs
      songIds = List<String>.from(userDoc.data()!['favorites']);
      songIds = songIds.reversed.toList();
      songIds = songIds.length > 3 ? songIds.sublist(0, 3) : songIds;
    } else {
      songIds = [];
    }
    try {
      // get a list of song objects based on the prev. fetched ids
      CollectionReference<Map<String, dynamic>> songsCollection =
          FirebaseFirestore.instance.collection('songs');

      List<Song> songs = [];

      for (String songId in songIds) {
        DocumentSnapshot<Map<String, dynamic>> songDoc =
            await songsCollection.doc(songId).get();

        if (songDoc.exists) {
          songs.add(
              Song.fromMap(songDoc.id, songDoc.data() as Map<String, dynamic>));
        }
      }
      return songs;
    } catch (error) {
      print('Error fetching songs: $error');
      rethrow;
    }
  }

  static Future<List<Song>> getUserCreatedPreview(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    List<String> songIds;
    if (userDoc.exists && userDoc.data()!['created'] is List) {
      // get the IDs of created songs
      songIds = List<String>.from(userDoc.data()!['created']);
      songIds = songIds.reversed.toList();
      songIds = songIds.length > 3 ? songIds.sublist(0, 3) : songIds;
    } else {
      songIds = [];
    }
    try {
      // get a list of song objects based on the prev. fetched ids
      CollectionReference<Map<String, dynamic>> songsCollection =
          FirebaseFirestore.instance.collection('songs');

      List<Song> songs = [];

      for (String songId in songIds) {
        DocumentSnapshot<Map<String, dynamic>> songDoc =
            await songsCollection.doc(songId).get();

        if (songDoc.exists) {
          songs.add(
              Song.fromMap(songDoc.id, songDoc.data() as Map<String, dynamic>));
        }
      }
      return songs;
    } catch (error) {
      print('Error fetching songs: $error');
      rethrow;
    }
  }

  static Future<PreviewData> getUserPreviews(String userId) async {
    List<Song> favoritesPreview = await getUserFavoritesPreview(userId);
    List<Song> createdPreview = await getUserCreatedPreview(userId);
    return PreviewData(favorites: favoritesPreview, created: createdPreview);
  }
}
