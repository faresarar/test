// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
// import 'package:photo_gallery/photo_gallery.dart';
// import 'package:path_provider/path_provider.dart';

// import '../mvc/model/models.dart';
// import '../mvc/view/dialogs.dart';
import '../tools.dart';

class ModernPicker {
  final BuildContext context;

  ModernPicker(this.context);

  static ModernPicker of(BuildContext context) {
    assert(context.mounted);
    return ModernPicker(context);
  }

  // static void showModernSingleImagePicker(
  //   BuildContext context, {
  //   /// On confirm picked images.
  //   required Future<void> Function(MediaNotifier) onPick,
  //   CropStyle cropStyle = CropStyle.rectangle,
  //   CropAspectRatio? cropAspectRatio,
  //   List<CropAspectRatioPreset> aspectRatioPresets = const [],
  // }) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => SingleImagePicker(
  //         mediumType: MediumType.image,
  //         cropAspectRatio: cropAspectRatio,
  //         aspectRatioPresets: aspectRatioPresets,
  //         cropStyle: cropStyle,
  //         onPick: onPick,
  //       ),
  //     ),
  //   );
  // }

  // static void showModernMultiImagePicker(
  //   BuildContext context, {
  //   /// On confirm picked images.
  //   required Future<void> Function(List<MediaNotifier>) onPick,

  //   /// Limit of the number of images
  //   int limit = 1,

  //   /// Update aspectRatio in MediaNotifier.
  //   bool updateAspectRatio = true,

  //   /// Aspect ratio of the picker card
  //   double cardAspectRatio = 1,
  // }) {
  //   //consider adding permission handling
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => MultiImagePicker(
  //         mediumType: MediumType.image,
  //         limit: limit,
  //         updateAspectRatio: updateAspectRatio,
  //         cardAspectRatio: cardAspectRatio,
  //         onPick: onPick,
  //       ),
  //     ),
  //   );
  // }

  Future<void> showClassicSingleImagePicker({
    required ImageSource source,
    required void Function(XFile) onComplete,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    bool checkPermission = true,
    bool crop = false,
  }) async {
    if (checkPermission) {
      if (source == ImageSource.camera &&
          await Permissions.of(context).showCameraPermission()) {
        return;
      } else if (source == ImageSource.gallery &&
          await Permissions.of(context).showPhotoLibraryPermission()) {
        return;
      }
    }
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(
      source: source,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      imageQuality: imageQuality,
    );
    if (pickedFile == null) return;
    if (crop) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        maxWidth: 512,
        maxHeight: 512,
        compressFormat: ImageCompressFormat.png,
        cropStyle: CropStyle.circle,
        aspectRatio: const CropAspectRatio(
          ratioX: 1,
          ratioY: 1,
        ),
        aspectRatioPresets: [CropAspectRatioPreset.square],
        uiSettings: [
          AndroidUiSettings(
            activeControlsWidgetColor: Theme.of(context).primaryColor,
            toolbarTitle: 'Cropper',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            minimumAspectRatio: 1,
            title: 'Cropper',
            aspectRatioLockEnabled: true,
            aspectRatioPickerButtonHidden: true,
            aspectRatioLockDimensionSwapEnabled: true,
            rotateButtonsHidden: true,
          ),
        ],
      );
      if (croppedFile == null) return;
      onComplete(XFile(croppedFile.path));
    } else {
      onComplete(pickedFile);
    }
  }

  // static Future<File> compressMedia(
  //   MediaNotifier media, {
  //   int minWidth = 1080,
  //   int minHeight = 1080,
  //   int quality = 70,
  // }) async {
  //   if (media.mediumType == MediumType.image) {
  //     File? result = await compressImage(
  //       media.file!.path,
  //     );
  //     return result!;
  //   } else {
  //     throw Exception('Compressing videos require package VideoCompress');
  //   }
  // }

  // static Future<File?> compressImage(
  //   String photoPath, {
  //   int minWidth = 1080,
  //   int minHeight = 1080,
  //   int quality = 70,
  // }) async {
  //   final dir = await getTemporaryDirectory();
  //   XFile? file = await FlutterImageCompress.compressAndGetFile(
  //     photoPath,
  //     '${dir.absolute.path}/compressed.jpg',
  //     minWidth: minWidth,
  //     minHeight: minHeight,
  //     quality: quality,
  //   );

  //   if (file != null) {
  //     return File(file.path);
  //   } else {
  //     return null;
  //   }
  // }

  ///upload image from local storage [photoPath] with [fileName] to `cloud storage`
  static Future<String> uploadImageFile({
    required String photoPath,
    required String root,
    required String fileName,
    // required bool compress,
  }) async {
    File? file =
        //  compress
        //     ? await compressImage(photoPath) ?? File(photoPath)
        //     :
        File(photoPath);
    UploadTask uploadTask;
    Reference ref =
        FirebaseStorage.instance.ref().child(root).child('/$fileName.jpg');
    uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() async {});
    return await uploadTask.snapshot.ref.getDownloadURL();
  }

  static Future<String> uploadImageData({
    required Uint8List imageData,
    required String root,
    required String fileName,
  }) async {
    UploadTask uploadTask;
    Reference ref =
        FirebaseStorage.instance.ref().child(root).child('/$fileName.jpg');
    uploadTask = ref.putData(imageData);
    await uploadTask.whenComplete(() async {});
    return await uploadTask.snapshot.ref.getDownloadURL();
  }

  static Future<String> uploadImageUI({
    required ui.Image image,
    required String root,
    required String fileName,
  }) async {
    ByteData? bytes = await image.toByteData();
    return await uploadImageData(
      imageData: bytes!.buffer.asUint8List(),
      root: root,
      fileName: fileName,
    );
  }

  static Future<double> getImageAspectRatioFromPath(String imagePath) async {
    File image = File(imagePath);
    var decodedImage = await decodeImageFromList(image.readAsBytesSync());
    Size size =
        Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());
    return size.aspectRatio;
  }

  static Future<Size> getImageSizeFromFile(File image) async {
    var decodedImage = await decodeImageFromList(image.readAsBytesSync());
    Size size =
        Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());
    return size;
  }
}
