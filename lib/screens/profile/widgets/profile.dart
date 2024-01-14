import 'package:flutter/material.dart';
import 'package:guitar_app/entities/app_user.dart';
import 'package:guitar_app/screens/profile/services/user_profile_service.dart';
import 'package:guitar_app/firebase/firebase_auth_services.dart';
import 'package:guitar_app/screens/profile/widgets/preview_widgets.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.user});
  final AppUser user;
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String? profilePicAddress = widget.user.picture;
  Future _changeProfilePicture(context) async {
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
                      {_buildShowDialog(context)}
                  },
                ),
              ),
            ),
          ),
          PreviewWidgets(user: widget.user)
        ],
      ),
    ]);
  }

  Future<dynamic> _buildShowDialog(BuildContext context) {
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
                    _changeProfilePicture(context),
                    Navigator.of(context, rootNavigator: true).pop("dialog")
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }
}
