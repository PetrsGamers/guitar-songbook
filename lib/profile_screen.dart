import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guitar_app/app_user.dart';
import 'package:guitar_app/firebase_auth_services.dart';
import 'package:guitar_app/profile.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key, this.userId});
  String? userId;

  Future<AppUser> getUserById(String documentId) async {
    var firestore = FirebaseFirestore.instance;
    var usersCollection = firestore.collection('users');

    var documentSnapshot = await usersCollection.doc(documentId).get();

    if (documentSnapshot.exists) {
      return AppUser.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    } else {
      throw Exception('User not found');
    }
  }

  Future<AppUser> getUserByNickname(String nickname) async {
    var firestore = FirebaseFirestore.instance;
    var usersCollection = firestore.collection('users');

    var querySnapshot =
        await usersCollection.where('name', isEqualTo: nickname).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      var userDoc = querySnapshot.docs.first;
      return AppUser.fromMap(userDoc.data() as Map<String, dynamic>);
    } else {
      throw Exception('User not found');
    }
  }

  final User? selfUser = Auth().currentUser;

  @override
  Widget build(BuildContext context) {
    bool viewingSelf = userId == null;
    if (selfUser == null) {
      return Text("Error fetching user data");
    }
    userId ??= selfUser!.uid;
    //return Text("${selfUser!.uid}");
    //print("object")
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          backgroundColor: Colors.green,
        ),
        body: FutureBuilder<AppUser>(
          future: getUserById(userId!),
          builder: (BuildContext context, AsyncSnapshot<AppUser> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              AppUser user = snapshot.data!;
              return Profile(viewingSelf: viewingSelf, user: user);
            } else {
              return Text('No user found');
            }
          },
        ));
  }
}

enum ListType { created, favorites }
