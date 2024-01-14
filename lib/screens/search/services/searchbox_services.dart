import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../entities/songs.dart';

class SearchBoxServices {
  static Future<Song> getSongbyId(String documentId) async {
    final firestore = FirebaseFirestore.instance;
    final songCollection = firestore.collection('songs');

    final documentSnapshot = await songCollection.doc(documentId).get();

    if (documentSnapshot.exists) {
      return Song.fromMap(
          documentId, documentSnapshot.data() as Map<String, dynamic>);
    } else {
      throw Exception('Song not found $documentId');
    }
  }
}
