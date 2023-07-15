import 'package:flutter/material.dart';

class UnhandledError extends StatelessWidget {
  final String error;
  const UnhandledError({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error,
        style: const TextStyle(
          fontSize: 24,
          color: Colors.red,
        ),
      ),
    );
  }
}
