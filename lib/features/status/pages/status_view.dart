import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsup/common/models/status.dart';
import 'package:whatsup/features/status/controller/status_controller.dart';

class StatusViewerPage extends ConsumerStatefulWidget {
  final StatusModel status;
  const StatusViewerPage({
    super.key,
    required this.status,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StatusViewPageState();
}

class _StatusViewPageState extends ConsumerState<StatusViewerPage> {
  final controller = StoryController();
  final List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    markDirty();
    initAllStatus();
  }

  void markDirty() {
    ref.read(statusControllerProvider).markSeenByCurrentUser(
          statusId: widget.status.statusId,
        );
  }

  void initAllStatus() {
    widget.status.texts.forEach((key, value) {
      storyItems.add(
        StoryItem.text(
          title: key,
          backgroundColor: Color(value),
          textStyle: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      );
    });
    for (final image in widget.status.photoUrl) {
      storyItems.add(
        StoryItem.pageImage(
          url: image,
          controller: controller,
          caption: '',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StoryView(
      storyItems: storyItems,
      controller: controller,
      inline: false,
      repeat: false,
      onComplete: () {
        Navigator.pop(context);
      },
    ));
  }
}
