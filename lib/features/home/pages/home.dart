import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/util/constants.dart';
import 'package:whatsup/common/util/ext.dart';
import 'package:whatsup/common/util/misc.dart';
import 'package:whatsup/features/home/widgets/chat_list.dart';
import 'package:whatsup/features/status/widgets/status_list.dart';
import 'package:whatsup/router.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with TickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);

    // update the state of the tab controller when the tab changes
    controller.addListener(() {
      if (controller.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    return DefaultTabController(
      length: controller.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(kAppName),
          bottom: TabBar(
            controller: controller,
            indicatorColor: themeMode == Brightness.light ? Colors.white : kPrimaryColor,
            labelColor: themeMode == Brightness.light ? Colors.white : kPrimaryColor,
            unselectedLabelColor: kUnselectedLabelColor,
            indicatorWeight: 4,
            tabs: const [
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
        body: TabBarView(
          controller: controller,
          children: const [
            ChatList(),
            StatusList(),
            Center(child: Text("Calls")),
          ],
        ),
        floatingActionButton: floatingWidgets,
      ),
    );
  }

  Widget get floatingWidgets {
    final lowerButton = FloatingActionButton(
      backgroundColor: kPrimaryColor,
      heroTag: 'lower',
      onPressed: () {
        if (controller.index == 1) {
          void pickStatusImage() async {
            final image = await pickGalleryImage(context);
            image.match(
              () => {},
              (file) {
                Navigator.pushNamed(context, PageRouter.statusImageConfirm, arguments: file);
              },
            );
          }

          pickStatusImage();
        } else {
          Navigator.pushNamed(context, PageRouter.selectContact);
        }
      },
      child: Icon(controller.index == 0 ? Icons.comment : Icons.photo_camera, color: Colors.white),
    );
    return Column(
      children: [
        const Spacer(),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 50),
              opacity: controller.index == 1 ? 1 : 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 185),
                height: controller.index == 1 ? 185 : 56,
                child: FloatingActionButton(
                  heroTag: 'writer',
                  onPressed: () {
                    Navigator.pushNamed(context, PageRouter.statusWriter);
                  },
                  backgroundColor: kDarkTextFieldBgColor,
                  mini: true,
                  child: const Icon(Icons.edit),
                ),
              ),
            ),
            lowerButton,
          ],
        ),
      ],
    );
  }
}
