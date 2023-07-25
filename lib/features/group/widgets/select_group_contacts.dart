import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/repositories/user.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/util/ext.dart';
import 'package:whatsup/common/widgets/error.dart';
import 'package:whatsup/common/widgets/list_tile_shimmer.dart';
import 'package:whatsup/common/widgets/progress.dart';
import 'package:whatsup/features/contact/repository/contact.dart';

final selectedGroupContacts = StateProvider<List<Contact>>((ref) => []);

class SelectGroupContacts extends ConsumerStatefulWidget {
  const SelectGroupContacts({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectGroupContactsState();
}

class _SelectGroupContactsState extends ConsumerState<SelectGroupContacts> {
  final List<int> selectedContacts = [];

  void toggleSelection(int i, Contact contact) {
    if (selectedContacts.contains(i)) {
      selectedContacts.remove(i);
    } else {
      selectedContacts.add(i);
    }
    setState(() {});
    ref.read(selectedGroupContacts.notifier).update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getAllContactProvider).when(
          data: (contacts) {
            return Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  final contactFetch = ref.watch(
                    userFetchByPhoneNumberProvider(contact.phones[0].normalizedNumber),
                  );
                  return contactFetch.when(
                    data: (userModel) {
                      // skip tile if user is not found
                      if (userModel.isNone()) {
                        return const SizedBox.shrink();
                      }
                      final contactUser = userModel.unwrap();
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        child: ListTile(
                          onTap: () {
                            toggleSelection(index, contact);
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(contactUser.profileImage),
                          ),
                          title: Text(contact.displayName),
                          subtitle: Text(contact.phones[0].normalizedNumber),
                          trailing: Checkbox(
                            fillColor: const MaterialStatePropertyAll(kPrimaryColor),
                            value: selectedContacts.contains(index),
                            onChanged: (value) {
                              toggleSelection(index, contact);
                            },
                          ),
                        ),
                      );
                    },
                    error: (err, trace) => UnhandledError(error: err.toString()),
                    loading: () => const ListTileShimmer(count: 2),
                  );
                },
              ),
            );
          },
          error: (err, trace) => UnhandledError(error: err.toString()),
          loading: () => const ListTileShimmer(count: 2),
        );
  }
}
