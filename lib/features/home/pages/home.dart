import 'package:flutter/material.dart';
import 'package:whatsup/common/util/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(kAppName),
        ),
        body: TabBar(
          tabs: [
            Tab(text: "Chat"),
            Tab(text: "Status"),
            Tab(text: "Calls"),
          ],
        ),
      ),
    );
  }
}
