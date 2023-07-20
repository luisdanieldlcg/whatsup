import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsup/common/enum/status.dart';
import 'package:whatsup/common/models/status.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/util/ext.dart';
import 'package:whatsup/common/widgets/error.dart';
import 'package:whatsup/common/widgets/progress.dart';
import 'package:whatsup/features/auth/controllers/auth.dart';
import 'package:whatsup/features/contact/repository/contact.dart';
import 'package:whatsup/features/status/controller/status_controller.dart';
import 'package:whatsup/features/status/widgets/user_status_loader.dart';
import 'package:whatsup/router.dart';

class StatusList extends ConsumerWidget {
  const StatusList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsFetcher = ref.watch(getAllContactProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const UserStatusLoader(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Recent updates",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade500,
            ),
          ),
        ),
        contactsFetcher.when(
          data: (contacts) {
            final liveContactStatus = ref.watch(contactStatusStreamProvider(contacts));
            return liveContactStatus.when(
              data: (statusList) {
                if (statusList.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 100),
                        Icon(Icons.photo_camera_outlined, size: 84),
                        SizedBox(height: 25),
                        Text('No status updates'),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: statusList.length,
                  itemBuilder: (context, index) {
                    final statusItem = statusList[index];
                    final createdAt = statusItem.createdAt;
                    final hasPassedOneMinute = DateTime.now().difference(createdAt).inMinutes > 1;
                    return ListTile(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          PageRouter.statusViewer,
                          arguments: statusItem,
                        );
                      },
                      leading: loadAvatar(ref, statusItem),
                      title: Text(statusItem.username),
                      subtitle: Text(
                        hasPassedOneMinute
                            ? DateFormat.Hm().format(createdAt)
                            : 'Just now ${DateFormat.Hm().format(createdAt)}',
                      ),
                    );
                  },
                );
              },
              error: (err, trace) => UnhandledError(error: err.toString()),
              loading: () => const Expanded(child: WorkProgressIndicator()),
            );
          },
          error: (err, trace) => UnhandledError(error: err.toString()),
          loading: () => const Expanded(child: WorkProgressIndicator()),
        ),
      ],
    );
  }

  Widget loadAvatar(WidgetRef ref, StatusModel model) {
    final userPhone = ref.read(authControllerProvider).currentUser.unwrap().phoneNumber;
    final isRead = model.seenBy.contains(userPhone);
    if (model.lastStatus == StatusType.text) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: kPrimaryColor,
            width: isRead ? 0 : 3,
          ),
        ),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Color(model.texts.values.last),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: 100,
                child: Text(
                  model.texts.keys.last,
                  textAlign: TextAlign.center,
                  maxLines: null,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: kPrimaryColor,
            width: isRead ? 0 : 3,
          ),
        ),
        child: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(model.photoUrl[0]),
        ),
      );
    }
  }
}
