import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guitar_app/app_user.dart';
import 'package:guitar_app/firebase_auth_services.dart';
import 'package:guitar_app/profile.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key, this.userId});
  final String? userId;

  Future<AppUser> getUserById(String documentId) async {
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

  Future<AppUser> getUserByNickname(String nickname) async {
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

  final User? currentUser = Auth().currentUser;

  @override
  Widget build(BuildContext context) {
    String userID;
    if (userId == null) {
      userID = currentUser!.uid;
    } else {
      userID = userId!;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: FutureBuilder<AppUser>(
            future: getUserById(userID),
            builder: (BuildContext context, AsyncSnapshot<AppUser> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.hasData) {
                AppUser user = snapshot.data!;
                return Profile(user: user);
              } else {
                return const Text('No user found');
              }
            },
          ),
        ));
  }
}

enum ListType { created, favorites }
