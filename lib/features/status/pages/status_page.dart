import 'package:flutter/material.dart';

class StatusList extends StatelessWidget {
  const StatusList({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Stack(
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
          )
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
