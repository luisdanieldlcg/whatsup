import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:whatsup/common/providers.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/util/ext.dart';

class ChatReplyCard extends ConsumerWidget {
  final String replyingTo;
  const ChatReplyCard({
    super.key,
    required this.replyingTo,
  });

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.notifier).update((state) => const None());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reply = ref.watch(messageReplyProvider).unwrap();
    final isDark = ref.watch(themeNotifierProvider) == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? kDarkTextFieldBgColor : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
        ),
      ),
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.only(top: 0, bottom: 12, left: 12, right: 0),
          decoration: BoxDecoration(
            color: isDark
                ? kReplyMessageColor.withOpacity(0.9)
                : const Color.fromARGB(255, 229, 229, 229).withOpacity(0.9),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    reply.isSenderMessage ? 'You' : replyingTo,
                    style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    splashRadius: 1,
                    padding: EdgeInsets.zero,
                    onPressed: () => cancelReply(ref),
                    icon: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.grey.shade700,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Text(
                reply.message,
                style: TextStyle(
                  color: isDark ? Colors.grey : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
