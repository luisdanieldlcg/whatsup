import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/util/constants.dart';
import 'package:whatsup/common/util/ext.dart';
import 'package:whatsup/common/util/file_picker.dart';
import 'package:whatsup/common/util/misc.dart';
import 'package:whatsup/features/group/controller/group_controller.dart';
import 'package:whatsup/features/group/widgets/select_group_contacts.dart';

class CreateGroupPage extends ConsumerStatefulWidget {
  const CreateGroupPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends ConsumerState<CreateGroupPage> {
  final groupNameController = TextEditingController();
  Option<File> groupImage = none();
  bool sending = false;

  void pickImage() async {
    groupImage = await FilePicker.pickFile(FilePickerSource.galleryImage);
    setState(() {});
  }

  void createGroup() async {
    if (groupNameController.text.isEmpty) {
      showSnackbar(context, "Please enter group name");
      return;
    }

    // make sure we don't send multiple requests
    if (!sending) {
      sending = true;
      ref.read(groupControllerProvider).createGroup(
            context: context,
            name: groupNameController.text.trim(),
            groupImage: groupImage,
            selectedContacts: ref.read(selectedGroupContacts),
          );
      ref.read(selectedGroupContacts.notifier).update((_) => const []);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("New Group"),
            SizedBox(height: 4),
            Text(
              "Add participants",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        leading: IconButton(
          splashRadius: kDefaultSplashRadius,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                if (groupImage.isNone()) ...{
                  CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    backgroundImage: const NetworkImage(
                      'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                    ),
                    radius: 60,
                  )
                } else ...{
                  CircleAvatar(
                    backgroundImage: FileImage(
                      groupImage.unwrap(),
                    ),
                    radius: 64,
                  ),
                },
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    splashRadius: kDefaultSplashRadius,
                    onPressed: pickImage,
                    icon: const Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
              child: TextField(
                controller: groupNameController,
                decoration: const InputDecoration(
                  hintText: "Type group subject here...",
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child: const Text(
                'Add participants',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SelectGroupContacts(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        backgroundColor: kPrimaryColor,
        child: const Icon(
          Icons.done_outlined,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
