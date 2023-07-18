import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/util/constants.dart';
import 'package:whatsup/features/home/widgets/chat_list.dart';
import 'package:whatsup/router.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(kAppName),
          bottom: TabBar(
            indicatorColor: themeMode == Brightness.light ? Colors.white : kPrimaryColor,
            labelColor: themeMode == Brightness.light ? Colors.white : kPrimaryColor,
            unselectedLabelColor: kUnselectedLabelColor,
            indicatorWeight: 4,
            tabs: [
              Tab(text: "Chat"),
              Tab(text: "Status"),
              Tab(text: "Calls"),
            ],
          ),
          actions: [
            // theme switcher
            IconButton(
              splashRadius: kDefaultSplashRadius,
              onPressed: () {
                ref.read(themeNotifierProvider.notifier).toggle();
              },
              icon: themeMode == Brightness.light
                  ? const Icon(Icons.nightlight_round)
                  : const Icon(Icons.wb_sunny),
            ),

            IconButton(
              splashRadius: kDefaultSplashRadius,
              onPressed: () {},
              icon: const Icon(Icons.photo_camera_outlined),
            ),
            IconButton(
              splashRadius: kDefaultSplashRadius,
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            IconButton(
              splashRadius: kDefaultSplashRadius,
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            ChatList(),
            Center(child: Text("Status")),
            Center(child: Text("Calls")),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          onPressed: () {
            Navigator.pushNamed(context, PageRouter.selectContact);
          },
          child: const Icon(Icons.comment, color: Colors.white),
        ),
      ),
    );
  }
}
