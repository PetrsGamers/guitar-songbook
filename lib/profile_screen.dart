import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guitar_app/app_user.dart';
import 'package:guitar_app/profile.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key, this.userId});
  final String? userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<AppUser> getUserById(String documentId) async {
    var firestore = FirebaseFirestore.instance;
    var usersCollection = firestore.collection('users');

    var documentSnapshot = await usersCollection.doc(documentId).get();

    if (documentSnapshot.exists) {
      return AppUser.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    } else {
      // Handle the case where the document does not exist
      throw Exception('User not found');
    }
  }

  Future<AppUser> getUserByNickname(String nickname) async {
    var firestore = FirebaseFirestore.instance;
    var usersCollection = firestore.collection('users');

    var querySnapshot = await usersCollection
        .where('name', isEqualTo: nickname) // Adjusted to query by nickname
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var userDoc = querySnapshot.docs.first;
      return AppUser.fromMap(userDoc.data() as Map<String, dynamic>);
    } else {
      // Handle the case where no user is found
      throw Exception('User not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool viewingSelf = widget.userId == null;
    if (widget.userId == null) {
      return Text(
          "TODO: Implement self profile once it is possible to fetch ID from Auth");
    }
    print("user id: ${widget.userId}");
    //print("object")
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          backgroundColor: Colors.green,
        ),
        //body: Profile(viewingSelf: viewingSelf),
        body: FutureBuilder<AppUser>(
          future: getUserById(widget.userId!),
          builder: (BuildContext context, AsyncSnapshot<AppUser> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while waiting for the future to complete
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Handle the error case
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              // The future is complete and returned data
              AppUser user = snapshot.data!;
              return Profile(viewingSelf: viewingSelf, user: user);
            } else {
              // Handle the case where the future completed with no data
              return Text('No user found');
            }
          },
        ));
  }
}

enum ListType { created, favorites }
