// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:whatsup/common/models/message.dart';
import 'package:whatsup/features/chat/widgets/bubble/chat_bubble_bottom.dart';

const double kBubbleRadius = 16;

class ImageBubble extends StatelessWidget {
  final String id;
  final Widget image;
  final double bubbleRadius;
  final bool isSender;
  final Color color;
  final bool tail;
  final MessageModel message;
  final bool isDark;
  final bool isReply;
  final void Function()? onTap;

  const ImageBubble({
    Key? key,
    required this.id,
    required this.image,
    this.bubbleRadius = kBubbleRadius,
    this.isSender = true,
    this.color = Colors.white70,
    this.tail = true,
    required this.message,
    required this.isDark,
    required this.isReply,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool stateTick = false;

    return Row(
      children: <Widget>[
        isSender
            ? const Expanded(
                child: SizedBox(
                  width: 5,
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .5,
                maxHeight: MediaQuery.of(context).size.width * .5),
            child: GestureDetector(
                child: Hero(
                  tag: id,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(bubbleRadius),
                            topRight: Radius.circular(bubbleRadius),
                            bottomLeft: Radius.circular(tail
                                ? isSender
                                    ? bubbleRadius
                                    : 0
                                : kBubbleRadius),
                            bottomRight: Radius.circular(tail
                                ? isSender
                                    ? 0
                                    : bubbleRadius
                                : kBubbleRadius),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(bubbleRadius),
                            child: image,
                          ),
                        ),
                      ),
                      // stateIcon != null && stateTick
                      //     ? Positioned(
                      //         bottom: 4,
                      //         right: 6,
                      //         child: stateIcon,
                      //       )
                      //     : SizedBox(
                      //         width: 1,
                      //       ),
                      Positioned(
                        bottom: 4,
                        right: 6,
                        child: ChatBubbleBottom(
                          model: message,
                          isDark: isDark,
                          isReply: isReply,
                        ),
                      )
                    ],
                  ),
                ),
                onTap: onTap ??
                    () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return _DetailScreen(
                          tag: id,
                          image: image,
                        );
                      }));
                    }),
          ),
        )
      ],
    );
  }
}

/// detail screen of the image, display when tap on the image bubble
class _DetailScreen extends StatefulWidget {
  final String tag;
  final Widget image;

  const _DetailScreen({Key? key, required this.tag, required this.image}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

/// created using the Hero Widget
class _DetailScreenState extends State<_DetailScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        body: Center(
          child: Hero(
            tag: widget.tag,
            child: widget.image,
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
