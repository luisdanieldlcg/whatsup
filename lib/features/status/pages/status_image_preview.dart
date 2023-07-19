import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/features/status/controller/status_controller.dart';

class StatusImageConfirmPage extends ConsumerWidget {
  final File file;
  const StatusImageConfirmPage({
    super.key,
    required this.file,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm your image"),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.file(file),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addStatus(ref, context),
        backgroundColor: kPrimaryColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }

  void addStatus(WidgetRef ref, BuildContext context) {
    ref.read(statusControllerProvider).uploadFileStatus(
          statusImage: file,
          context: context,
        );
    Navigator.pop(context);
  }
}
