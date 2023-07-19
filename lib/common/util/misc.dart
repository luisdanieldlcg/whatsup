import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      closeIconColor: Colors.white,
      content: Text(message),
      duration: const Duration(seconds: 3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );
}

Future<Option<File>> pickGalleryImage(BuildContext context) async {
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    final file = image == null ? null : File(image.path);
    return Option.fromNullable(file);
  } catch (e) {
    showSnackbar(context, e.toString());
    return const Option.none();
  }
}

Future<Option<File>> pickVideoFromGallery(BuildContext context) async {
  try {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    final file = video == null ? null : File(video.path);
    return Option.fromNullable(file);
  } catch (e) {
    showSnackbar(context, e.toString());
    return const Option.none();
  }
}

String removePhoneDecoration(String phone) {
  return phone.replaceAll(' ', '').replaceAll('(', '').replaceAll(')', '').replaceAll('-', '');
}
