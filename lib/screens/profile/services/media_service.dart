import 'package:flutter/material.dart';
import 'package:guitar_app/common/helpers.dart';
import 'package:guitar_app/entities/profile_picture.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MediaService {
  static Future<XFile?> _getImageFromLocalStorage() async {
    XFile? selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selectedImage == null) {
      return null; // user has canceled
    }
    return selectedImage;
  }

  static Future<CroppedFile?> _getCroppedImage(
      context, XFile selectedImage) async {
    return ImageCropper().cropImage(
      sourcePath: selectedImage.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Profile Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true),

        /// this settings is required for Web
        WebUiSettings(
          context: context,
          mouseWheelZoom: true,
          presentStyle: CropperPresentStyle.dialog,
          boundary: const CroppieBoundary(
            width: 300,
            height: 300,
          ),
          viewPort:
              const CroppieViewPort(width: 280, height: 280, type: 'circle'),
          enableExif: false,
          enableZoom: true,
          showZoomer: true,
        )
      ],
    );
  }

  static Future<ProfilePicture?> getCroppedImageFromStorage(context) async {
    XFile? selectedImage = await _getImageFromLocalStorage();
    if (selectedImage == null) {
      return null;
    }
    CroppedFile? croppedImage = await _getCroppedImage(context, selectedImage);
    if (croppedImage == null) {
      return null;
    }
    String fileExtension = getFileExtensionFromMime(selectedImage.mimeType);
    return ProfilePicture(
        imageFile: croppedImage, fileExtension: fileExtension);
  }
}
