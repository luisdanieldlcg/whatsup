import 'package:flutter/material.dart';

class WorkProgressIndicator extends StatelessWidget {
  const WorkProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
