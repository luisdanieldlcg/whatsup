import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:whatsup/common/repositories/user.dart';
import 'package:whatsup/common/util/file_picker.dart';
import 'package:whatsup/common/util/misc.dart';
import 'package:whatsup/router.dart';

class CreateProfilePage extends ConsumerStatefulWidget {
  const CreateProfilePage({super.key});

  @override
  ConsumerState<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends ConsumerState<CreateProfilePage> {
  Option<File> profilePic = const Option.none();
  final nameController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void pickProfilePic() async {
    profilePic = await FilePicker.pickFile(FilePickerSource.galleryImage);
    setState(() {});
  }

  CircleAvatar get profileImage {
    const size = 64.0;
    return profilePic.match(
      () => CircleAvatar(
        backgroundColor: Colors.grey.withOpacity(.2),
        backgroundImage: const NetworkImage(
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
        ),
        radius: size,
      ),
      (pic) => CircleAvatar(
        backgroundImage: FileImage(pic),
        radius: size,
      ),
    );
  }

  Widget get loadingIndicator {
    return const Center(
      child: Column(
        children: [
          Spacer(flex: 2),
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              strokeWidth: 6.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          Spacer(flex: 3),
        ],
      ),
    );
  }

  void onFinish() async {
    if (nameController.text.isEmpty) {
      showSnackbar(context, "Please enter your name");
      return;
    }
    setState(() {
      loading = true;
    });
    ref.read(userRepositoryProvider).create(
          name: nameController.text,
          avatar: profilePic,
          onError: (error) => showSnackbar(context, error),
          onSuccess: () => {
            Navigator.pushNamedAndRemoveUntil(context, PageRouter.home, (route) => false),
          },
        );
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create your profile"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: onFinish,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: loading
          ? loadingIndicator
          : Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Stack(
                    children: [
                      profileImage,
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: pickProfilePic,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: "Enter your name",
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
