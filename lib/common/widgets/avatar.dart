import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class Avatar extends StatelessWidget {
  final Option<Uint8List> image;
  const Avatar({
    super.key,
    this.image = const None(),
  });

  @override
  Widget build(BuildContext context) {
    return image.match(
      () => const CircleAvatar(
        backgroundColor: Color.fromRGBO(207, 218, 221, 1),
        child: Icon(Icons.person, color: Colors.white),
      ),
      (bytes) => CircleAvatar(
        backgroundImage: MemoryImage(bytes),
      ),
    );
  }
}
