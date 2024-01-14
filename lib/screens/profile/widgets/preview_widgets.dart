import 'package:flutter/material.dart';
import 'package:guitar_app/entities/app_user.dart';
import 'package:guitar_app/screens/profile/services/user_profile_service.dart';
import 'package:guitar_app/screens/profile/widgets/created_preview.dart';
import 'package:guitar_app/screens/profile/widgets/favorite_preview.dart';

class PreviewWidgets extends StatelessWidget {
  const PreviewWidgets({super.key, required this.user});
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 140), // pad the top profile background
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(user.name, style: const TextStyle(fontSize: 34)),
            ),
            FutureBuilder(
              future: UserProfileService.getUserPreviews(user.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: CircularProgressIndicator(),
                  ));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return Column(children: [
                  FavoritePreview(
                      userId: user.id, songList: snapshot.data!.favorites),
                  CreatedPreview(
                      userId: user.id, songList: snapshot.data!.created)
                ]);
              },
            )
          ],
        ));
  }
}
