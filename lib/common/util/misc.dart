import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
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
