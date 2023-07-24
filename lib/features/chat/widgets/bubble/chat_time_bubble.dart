import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsup/common/theme.dart';

class ChatTimeBubble extends ConsumerWidget {
  final DateTime time;
  const ChatTimeBubble({
    Key? key,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeNotifierProvider) == Brightness.dark;
    final bubbleColor = isDark ? kReceiverMessageColorDark : Colors.white;
    return Bubble(
      alignment: Alignment.center,
      color: bubbleColor,
      borderWidth: 0.5,
      borderColor: isDark ? Colors.grey.shade800 : Colors.grey.shade400,
      margin: const BubbleEdges.symmetric(vertical: 7),
      child: Text(
        formatTimestamp(time),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14.0, color: isDark ? Colors.white : Colors.grey.shade800),
      ),
    );
  }

  String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp).abs();
    if (diff.inHours < 24) {
      return 'Today';
    } else if (diff.inHours < 48) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(timestamp);
    }
  }
}
