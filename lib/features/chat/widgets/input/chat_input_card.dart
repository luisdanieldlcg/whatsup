// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:whatsup/common/theme.dart';
import 'package:whatsup/features/chat/widgets/input/chat_input_action.dart';

class ChatAttachmentCard extends StatelessWidget {
  final double height;
  final bool isDark;
  final VoidCallback openImageGallery;
  final VoidCallback openCamera;
  final VoidCallback openVideoGallery;
  const ChatAttachmentCard({
    Key? key,
    required this.height,
    required this.isDark,
    required this.openImageGallery,
    required this.openCamera,
    required this.openVideoGallery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: height,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? kDarkTextFieldBgColor : kLightTextFieldBgColor,
        boxShadow: height == 0
            ? [] // no shadow if the height is 0
            : [
                BoxShadow(
                  color: isDark ? Colors.black12 : Colors.grey.withOpacity(0.8),
                  spreadRadius: 0.5,
                  blurRadius: 1,
                  offset: Offset.zero,
                ),
              ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
        children: [
          ChatInputAction(
            onClick: openImageGallery,
            icon: Icons.image,
            title: 'Gallery',
            bgColor: Colors.purple,
          ),
          ChatInputAction(
            onClick: openCamera,
            icon: Icons.camera_alt,
            title: 'Camera',
            bgColor: Colors.red,
          ),
          ChatInputAction(
            onClick: openVideoGallery,
            icon: Icons.video_collection_sharp,
            title: 'Video',
            bgColor: Colors.blue,
          ),
          ChatInputAction(
            onClick: () {},
            icon: Icons.location_on,
            title: 'Location',
            bgColor: Colors.green,
          ),
          ChatInputAction(
            onClick: () {},
            icon: Icons.person,
            title: 'Contact',
            bgColor: Colors.orange,
          ),
          ChatInputAction(
            onClick: () {},
            icon: Icons.music_note,
            title: 'Audio',
            bgColor: Colors.purple,
          ),
          ChatInputAction(
            onClick: () {},
            icon: Icons.document_scanner,
            title: 'Document',
            bgColor: Colors.pink,
          ),
        ],
      ),
    );
  }
}
