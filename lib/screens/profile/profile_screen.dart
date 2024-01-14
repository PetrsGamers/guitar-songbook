import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guitar_app/entities/app_user.dart';
import 'package:guitar_app/firebase/firebase_auth_services.dart';
import 'package:guitar_app/screens/profile/services/user_profile_service.dart';
import 'package:guitar_app/screens/profile/widgets/profile.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key, this.userId});
  final String? userId;

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
        ),
        body: Center(
          child: FutureBuilder<AppUser>(
            future: UserProfileService.getUserById(userID),
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
