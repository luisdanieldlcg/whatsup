import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:whatsup/common/util/misc.dart';

class CreateProfilePage extends ConsumerStatefulWidget {
  const CreateProfilePage({super.key});

  @override
  ConsumerState<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends ConsumerState<CreateProfilePage> {
  Option<File> profilePic = const Option.none();
  final nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void pickProfilePic() async {
    profilePic = await pickGalleryImage(context);
    setState(() {});
  }

  CircleAvatar get profileImage {
    const size = 64.0;
    return profilePic.match(
      () => const CircleAvatar(
        backgroundImage: NetworkImage(
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

  void onFinish() {}

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
      body: Center(
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 36),
              child: TextField(
                decoration: InputDecoration(
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
