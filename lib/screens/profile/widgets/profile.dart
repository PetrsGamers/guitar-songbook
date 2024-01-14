import 'package:flutter/material.dart';
import 'package:guitar_app/entities/app_user.dart';
import 'package:guitar_app/screens/profile/services/user_profile_service.dart';
import 'package:guitar_app/screens/profile/widgets/created_preview.dart';
import 'package:guitar_app/screens/profile/widgets/favorite_preview.dart';
import 'package:guitar_app/firebase/firebase_auth_services.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.user});
  final AppUser user;
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String? profilePicAddress = widget.user.picture;
  Future changeProfilePicture(context) async {
    String? downloadURL =
        await UserProfileService.changeProfilePicture(context);
    if (downloadURL == null) {
      return; // user has cancelled the select
    }
    setState(() {
      profilePicAddress = downloadURL;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            height: 140,
            color: Theme.of(context).canvasColor,
          ),
          Positioned(
            top: 80,
            right: 40,
            child: CircleAvatar(
              radius: 60,
              backgroundImage: widget.user.picture.isEmpty
                  ? null
                  : NetworkImage(profilePicAddress!),
              backgroundColor: Colors.black,
              child: Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => {
                    if (widget.user.id == Auth().currentUser!.uid)
                      {buildShowDialog(context)}
                  },
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                  top: 140), // pad the top profile background
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(widget.user.name,
                        style: const TextStyle(fontSize: 34)),
                  ),
                  FavoritePreview(userId: widget.user.id),
                  CreatedPreview(userId: widget.user.id)
                ],
              ))
        ],
      ),
    ]);
  }

  Future<dynamic> buildShowDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("Change Profile picture"),
              content: const Text(
                  'Do you really want to change your profile picture?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop("dialog"),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => {
                    changeProfilePicture(context),
                    Navigator.of(context, rootNavigator: true).pop("dialog")
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }
}
