import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:guitar_app/entities/app_user.dart';
import 'package:guitar_app/screens/profile/widgets/created_preview.dart';
import 'package:guitar_app/screens/profile/widgets/favorite_preview.dart';
import 'package:guitar_app/firebase/firebase_auth_services.dart';
import 'package:guitar_app/helpers.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.user});
  final AppUser user;
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String? profilePicAddress = widget.user.picture;
  Future changeProfilePicture(context) async {
    XFile? selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    // XFile? selectedImage = await ImagePicker.platform
    //     .getImageFromSource(source: ImageSource.gallery);
    if (selectedImage == null) {
      return; // user has canceled
    }
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: selectedImage.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true),

        /// this settings is required for Web
        WebUiSettings(
          context: context,
          mouseWheelZoom: true,
          presentStyle: CropperPresentStyle.dialog,
          boundary: CroppieBoundary(
            width: 520,
            height: 520,
          ),
          viewPort: CroppieViewPort(width: 480, height: 480, type: 'circle'),
          enableExif: false,
          enableZoom: true,
          showZoomer: true,
        )
      ],
    );
    if (croppedImage == null) {
      return;
    }
    final storageRef = FirebaseStorage.instance.ref();
    String fileExtension = getFileExtensionFromMime(selectedImage.mimeType);
    final destinationReference = storageRef
        .child("/profile_pictures/${DateTime.timestamp()}.$fileExtension");
    //final File uploadFile = File(croppedImage.path);
    final uploadFile = await croppedImage.readAsBytes();
    await destinationReference.putData(uploadFile);

    String downloadURL = await destinationReference.getDownloadURL();
    final collection = FirebaseFirestore.instance.collection('users');
    collection
        .doc(widget.user.id)
        .update({'picture': downloadURL})
        .then((_) => print('Successfully added new pictureURL to user'))
        .catchError((error) => print('Failed: $error'));
    setState(() {
      profilePicAddress = downloadURL;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          height: 140,
          color: Colors.lightGreen,
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
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: InkWell(
                onTap: () => {
                  if (widget.user.id == Auth().currentUser!.uid)
                    {
                      showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text("Change Profile picture"),
                                content: const Text(
                                    'Do you really want to change your profile picture?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.of(context,
                                            rootNavigator: true)
                                        .pop("dialog"),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => {
                                      changeProfilePicture(context),
                                      Navigator.of(context, rootNavigator: true)
                                          .pop("dialog")
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ))
                    }
                  else
                    {print("ignoring tap")}
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
                Text(widget.user.name, style: const TextStyle(fontSize: 32)),
                FavoritePreview(userId: widget.user.id),
                CreatedPreview(userId: widget.user.id)
              ],
            ))
      ],
    );
  }
}
