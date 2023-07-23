import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/enum/status.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/util/constants.dart';
import 'package:whatsup/common/util/file_picker.dart';
import 'package:whatsup/common/util/misc.dart';
import 'package:whatsup/common/widgets/error.dart';
import 'package:whatsup/common/widgets/progress.dart';
import 'package:whatsup/features/status/controller/status_controller.dart';
import 'package:whatsup/router.dart';

class UserStatusLoader extends ConsumerWidget {
  const UserStatusLoader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusLive = ref.watch(userStatusStreamProvider);
    return statusLive.when(
      data: (maybeStatus) {
        return maybeStatus.match(
          () => UserListTile(
            onTap: () {
              void pickStatusImage() async {
                final image = await FilePicker.pickFile(FilePickerSource.galleryImage);
                image.match(
                  () {},
                  (file) {
                    Navigator.pushNamed(context, PageRouter.statusImageConfirm, arguments: file);
                  },
                );
              }

              pickStatusImage();
            },
          ),
          (model) {
            final lastStatus = model.lastStatus;
            return UserListTile(
              onTap: () {
                Navigator.pushNamed(context, PageRouter.statusViewer, arguments: model);
              },
              leading: CircleAvatar(
                radius: 30,
                backgroundImage:
                    lastStatus == StatusType.image ? NetworkImage(model.photoUrl.last) : null,
                child: lastStatus == StatusType.text
                    ? CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(model.texts.values.last),
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
                      )
                    : null,
              ),
              trailing: PopupMenuButton(
                splashRadius: kDefaultSplashRadius,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      onTap: () {
                        ref.read(statusControllerProvider).deleteUserStatus(
                              model.statusId,
                              context,
                            );
                      },
                      child: const ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Delete'),
                      ),
                    ),
                  ];
                },
              ),
            );
          },
        );
      },
      error: (err, trace) => UnhandledError(error: err.toString()),
      loading: () => const WorkProgressIndicator(),
    );
  }
}

class UserListTile extends ConsumerWidget {
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  const UserListTile({
    super.key,
    this.leading,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeNotifierProvider) == Brightness.dark;
    return ListTile(
      onTap: onTap,
      trailing: trailing,
      leading: leading ??
          Stack(
            children: [
              const Icon(
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
                      color: isDark ? Colors.black : Colors.white,
                    ),
                  ),
                  color: Colors.black,
                  child: const CircleAvatar(
                    backgroundColor: kPrimaryColor,
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
          ),
      title: const Text(
        'My Status',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: const Text('Tap to add status update'),
    );
  }
}
