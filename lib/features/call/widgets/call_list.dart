import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsup/common/models/user.dart';
import 'package:whatsup/common/repositories/auth.dart';
import 'package:whatsup/common/repositories/user.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/util/ext.dart';
import 'package:whatsup/common/widgets/error.dart';
import 'package:whatsup/common/widgets/progress.dart';
import 'package:whatsup/features/call/controller/call_controller.dart';
import 'package:whatsup/features/call/widgets/call_invitation_button.dart';

class CallList extends ConsumerStatefulWidget {
  const CallList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallListState();
}

class _CallListState extends ConsumerState<CallList> {
  @override
  Widget build(BuildContext context) {
    final liveCalls = ref.watch(userCallStreamProvider);
    return liveCalls.when(
      data: (calls) {
        if (calls.isEmpty) {
          return const Column(
            children: [
              SizedBox(height: 200),
              Center(
                child: Text("No recent calls"),
              ),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "Recent",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: calls.length,
              itemBuilder: (context, index) {
                final call = calls[index];
                final wasMadeByMe =
                    call.callerId == ref.read(authRepositoryProvider).currentUser.unwrap().uid;
                final wasDeclinedOrMissed = call.missedOrDeclined;

                Color arrowColor() {
                  // always green if it was made by me
                  if (wasMadeByMe) return kPrimaryColor.withGreen(190);
                  return wasDeclinedOrMissed ? Colors.red : kPrimaryColor.withGreen(190);
                }

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(wasMadeByMe ? call.receiverImage : call.callerImage),
                  ),
                  title: Text(wasMadeByMe ? call.receiverName : call.callerName),
                  subtitle: Row(
                    children: [
                      // add arrow icon if it was missed or declined
                      Icon(
                        Icons.arrow_outward_outlined,
                        color: arrowColor(),
                        size: 18,
                      ),
                      Text(
                        // format like this: June 2, 19:36 or Yesterday, 19:36 if it was time <= 24 hours ago
                        DateFormat(
                                call.date.isBefore(DateTime.now().subtract(const Duration(days: 1)))
                                    ? "MMMM d, HH:mm"
                                    : "EEEE, HH:mm")
                            .format(call.date),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
      error: (error, trace) => UnhandledError(error: error.toString()),
      loading: () => const WorkProgressIndicator(),
    );
  }
}
