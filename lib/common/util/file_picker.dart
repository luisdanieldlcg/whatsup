import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsup/common/util/logger.dart';

enum FilePickerSource {
  camera,
  galleryImage,
  galleryVideo,
}

class FilePicker {
  static final _logger = AppLogger.getLogger((FilePicker).toString());

  static Future<Option<File>> pickFile(FilePickerSource src) async {
    try {
      _logger.d('Picking file from $src');
      final instance = ImagePicker();
      final crossFile = await switch (src) {
        FilePickerSource.camera => instance.pickImage(source: ImageSource.camera),
        FilePickerSource.galleryImage => instance.pickImage(source: ImageSource.gallery),
        FilePickerSource.galleryVideo => instance.pickVideo(source: ImageSource.gallery),
      };
      final intoFile = crossFile == null ? null : File(crossFile.path);
      return Option.fromNullable(intoFile);
    } catch (e) {
      _logger.e(e);
      return const Option.none();
    }
  }
}
