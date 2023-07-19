import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsup/common/enum/status.dart';
import 'package:whatsup/common/models/status.dart';
import 'package:whatsup/common/widgets/error.dart';
import 'package:whatsup/common/widgets/progress.dart';
import 'package:whatsup/features/status/controller/status_controller.dart';
import 'package:whatsup/router.dart';

class StatusList extends ConsumerWidget {
  const StatusList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveStatus = ref.watch(getStatusProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        loadMyStatus(ref),
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
        liveStatus.when(
          data: (status) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: status.length,
              itemBuilder: (context, index) {
                final statusItem = status[index];
                final createdAt = statusItem.createdAt;

                // check if it has passed 1 minute
                final hasPassedOneMinute = DateTime.now().difference(createdAt).inMinutes > 1;
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, PageRouter.statusViewer, arguments: statusItem);
                  },
                  leading: loadAvatar(statusItem),
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
          loading: () => const WorkProgressIndicator(),
        ),
      ],
    );
  }

  Widget loadAvatar(StatusModel model) {

    if (model.lastStatus == StatusType.text) {
      return CircleAvatar(
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
                style:
                    const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      );
    } else {
      // assume this is a image status
      return CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(model.photoUrl[0]),
      );
    }
  }

  Widget loadMyStatus(WidgetRef ref) {
    final userStatusListener = ref.watch(userStatusStreamProvider);
    return userStatusListener.when(
      data: (status) {
        return ListTile(
          leading: status.isEmpty
              ? defaultStatusAvatar
              : Builder(builder: (context) {
                  return CircleAvatar(
                    radius: 30,
                    backgroundImage: status.last.lastStatus == StatusType.image
                        ? NetworkImage(status.last.photoUrl.last)
                        : null,
                    child: status.last.lastStatus == StatusType.text
                        ? CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(status.last.texts.values.last),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: SizedBox(
                                width: 100,
                                child: Text(
                                  status.last.texts.keys.last,
                                  textAlign: TextAlign.center,
                                  maxLines: null,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          )
                        : null,
                  );
                }),
          title: const Text(
            'My Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: const Text('Tap to add status update'),
        );
      },
      error: (err, trace) => UnhandledError(error: err.toString()),
      loading: () => const ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Icon(
            Icons.account_circle,
            size: 54,
          ),
        ),
        title: Text('My Status'),
        subtitle: Text('Tap to add status update'),
      ),
    );
  }

  Widget get defaultStatusAvatar {
    return const Stack(
      children: [
        Icon(
          Icons.account_circle,
          size: 54,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Material(
            shape: CircleBorder(
              side: BorderSide(
                width: 2,
                color: Colors.black,
              ),
            ),
            color: Colors.black,
            child: CircleAvatar(
              backgroundColor: Colors.green,
              radius: 11,
              child: Icon(
                Icons.add,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
