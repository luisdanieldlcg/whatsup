import 'package:flutter/material.dart';

class ChatInputAction extends StatelessWidget {
  final VoidCallback onClick;
  final IconData icon;
  final String title;
  final Color bgColor;
  const ChatInputAction({
    Key? key,
    required this.onClick,
    required this.icon,
    required this.title,
    required this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          shape: const CircleBorder(),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  bgColor,
                  bgColor.withOpacity(0.6),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onClick,
              child: IconButton(
                onPressed: null,
                icon: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
