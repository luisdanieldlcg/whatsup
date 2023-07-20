import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:whatsup/common/util/constants.dart';
import 'package:whatsup/common/util/misc.dart';
import 'package:whatsup/common/widgets/avatar.dart';
import 'package:whatsup/common/widgets/error.dart';
import 'package:whatsup/common/widgets/progress.dart';
import 'package:whatsup/features/contact/controllers/contact.dart';
import 'package:whatsup/router.dart';

class SelectContactPage extends ConsumerWidget {
  const SelectContactPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(readAllContactsProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select contact',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (contacts.hasValue && contacts.value != null) ...{
              const SizedBox(height: 4),
              Text(
                '${contacts.value!.length} contacts',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            }
          ],
        ),
      ),
      body: contacts.when(
        data: (contacts) {
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return InkWell(
                onTap: () => goToContact(ref, contact, context),
                child: ListTile(
                  title: Text(
                    contact.displayName,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  leading: Avatar(
                    image: Option.fromNullable(contact.photo),
                  ),
                ),
              );
            },
          );
        },
        error: (err, trace) => UnhandledError(error: err.toString()),
        loading: () => const WorkProgressIndicator(),
      ),
    );
  }

  void goToContact(WidgetRef ref, Contact con, BuildContext context) {
    ref.read(selectContactProvider).findContact(
          selected: con,
          contactNotFound: () => showSnackbar(
            context,
            "This contact is not registered on $kAppName",
          ),
          contactFound: (user) {
            Navigator.pushReplacementNamed(context, PageRouter.chat, arguments: {
              'isGroup': false,
              'streamId': user.uid,
              'name': user.name,
              'avatarImage': user.profileImage,
            });
          },
        );
  }
}
